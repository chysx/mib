import 'package:dio/dio.dart';
import 'package:mib/db/manager/app_log_manager.dart';
import 'package:mib/exception/exception_type.dart';
import 'package:mib/log/log_util.dart';
import 'package:mib/synchronization/base/abstract_request.dart';
import 'package:mib/synchronization/base/abstract_sync_mode.dart';
import 'package:mib/synchronization/sync/sync_status.dart';
import 'package:rxdart/rxdart.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/7/29 15:29

class RxRequest extends AbstractRequest<Response<Map<String, dynamic>>> {
  RxRequest(AbstractSyncMode syncMode) : super(syncMode);

  @override
  Future execute(Observable<Response<Map<String, dynamic>>> observable, {onSuccessSync, onFailSync}) async {
    await AppLogManager.insert(ExceptionType.INFO.toString(), msg: syncMode.syncType.toString());

    observable.flatMap((syncDataBean) {
      return Observable.fromFuture(syncMode.parser.parse(syncDataBean));
    }).map((isSuccess) {
      if (!isSuccess) {
//        AppLogManager.insert(
//            ExceptionType.WARN.toString(), syncDataBean.toString());
      }
      return isSuccess;
    }).listen((isSuccess) async {
      if (isSuccess) {
        await AppLogManager.insert(
            ExceptionType.INFO.toString(), msg: syncMode.syncType.toString() + ":" + SyncStatus.SYNC_SUCCESS.toString());
        syncMode.onSuccess();
        if (onSuccessSync != null) {
          onSuccessSync();
        }
      } else {
        AppLogManager.insert(
            ExceptionType.INFO.toString(), msg: syncMode.syncType.toString() + ":" + SyncStatus.SYNC_FAIL.toString());
        syncMode.onFail();
        if (onFailSync != null) {
          onFailSync(new Exception("False"));
        }
      }
    }, onError: (e) async {

      syncMode.onFinish();

      await AppLogManager.insert(ExceptionType.WARN.toString(), error: e);
      Log().logger.e(e.toString());
      try {
        await AppLogManager.insert(
            ExceptionType.INFO.toString(), msg: syncMode.syncType.toString() + ":" + SyncStatus.SYNC_FAIL.toString());
        syncMode.onFail();
      } catch (ex) {
        Log().logger.e(e.toString());
        AppLogManager.insert(ExceptionType.WARN.toString(), error: ex);
      }

      try {
        if (onFailSync != null) {
          onFailSync(e);
        }
      } catch (ex) {
        Log().logger.e(ex.toString());
        await AppLogManager.insert(ExceptionType.WARN.toString(), error: ex);
      }

    }, onDone: () {
      syncMode.onFinish();
    });
  }
}
