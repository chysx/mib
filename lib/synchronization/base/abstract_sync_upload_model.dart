import 'package:dio/dio.dart';
import 'package:mib/db/database.dart';
import 'package:mib/db/manager/sync_upload_manager.dart';
import 'package:mib/db/table/sync_upload_entity.dart';
import 'package:mib/net/api_service.dart';
import 'package:mib/synchronization/bean/sync_request_bean.dart';
import 'package:mib/synchronization/bean/table_uploade_bean.dart';
import 'package:mib/synchronization/impl/upload_parser.dart';
import 'package:mib/synchronization/impl/upload_request_create.dart';
import 'package:mib/synchronization/sync/sync_call_back.dart';
import 'package:mib/synchronization/sync/sync_dirty_status.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:mib/synchronization/sync/sync_status.dart';
import 'package:mib/synchronization/sync/sync_type.dart';
import 'package:mib/synchronization/utils/sync_sql_util.dart';
import 'package:flustars/flustars.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqlite_api.dart' as sqlite_api;

import 'abstract_sync_mode.dart';
import 'i_sync_upload.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/7/29 12:06

abstract class AbstractSyncUploadModel extends AbstractSyncMode<Future<SyncRequestBean>, Response<Map<String, dynamic>>>
    implements ISyncUpload {
  AbstractSyncUploadModel(SyncType syncType,
      {SyncParameter syncParameter, OnSuccessSync onSuccessSync, OnFailSync onFailSync})
      : super(syncType, syncParameter: syncParameter, onSuccessSync: onSuccessSync, onFailSync: onFailSync) {
    parser = new UploadParser(this);
    requestCreate = new UploadRequestCreate(this);
  }

  Future<Observable<Response<Map<String, dynamic>>>> prepare() async {
    return Observable.fromFuture(requestCreate.create()).flatMap((syncRequestBean) {
      return Observable.fromFuture(ApiService.getSyncDataByUpload(syncRequestBean));
    });
  }

  Future onSuccess() async {
    super.onSuccess();

    await updateDirty(SyncDirtyStatus.SUCCESS);
    await updateStatus(SyncStatus.SYNC_SUCCESS);
  }

  Future onFail() async {
    super.onFail();

    await updateDirty(SyncDirtyStatus.FAIL);
    await updateStatus(SyncStatus.SYNC_FAIL);
  }

  Future onLoad() async {
    super.onLoad();

    await updateStatus(SyncStatus.SYNC_LOAD);
  }

  List<String> getUploadUniqueIdValues() {
    return syncParameter.getUploadUniqueIdValues();
  }

  void policy() {}

  bool isAllDataAndAllInsert(String tableName) {
    return false;
  }

  Future updateDirty(String syncDirtyStatus) async {
    await updateUploadDirty(getTableUploadList(), syncDirtyStatus);
  }

  Future updateUploadDirty(List<TableUploadBean> uploadBeanList, String dirty) async {
    sqflite.DatabaseExecutor sqfliteDb = DbHelper().database.database;
    sqlite_api.Database database = sqfliteDb as sqlite_api.Database;
    database.transaction((txn) async {
      for (TableUploadBean uploadBean in uploadBeanList) {
        await txn.execute(uploadBean.getSqlUpdateBuild(), [dirty]);
      }
    });
  }

  Future updateStatus(SyncStatus syncStatus) async {
    SyncUploadEntity syncUploadEntity = new SyncUploadEntity.Empty();
    if (syncParameter.getUploadUniqueIdValues() == null || syncParameter.getUploadUniqueIdValues().length == 0) {
      syncUploadEntity.uniqueIdValues = null;
    } else {
      syncUploadEntity.uniqueIdValues = SyncSqlUtil.getStringByUniqueIdValues(syncParameter.getUploadUniqueIdValues());
    }
    syncUploadEntity.name = syncParameter.getUploadName();
    syncUploadEntity.status = syncStatus.toString();
    syncUploadEntity.type = syncType.toString();
    syncUploadEntity.time = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL);
    await SyncUploadManager.deleteAndInsert(syncUploadEntity);
  }
}
