import 'package:mib/application.dart';
import 'package:mib/synchronization/bean/sync_request_bean.dart';
import 'package:mib/synchronization/sync/sync_constant.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:package_info/package_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/7/30 19:05

class SyncUtil {
  static Future<SyncRequestBean> createSyncDataRequestBean(SyncParameter syncParameter) async {
    SyncRequestBean syncDataRequestBean = new SyncRequestBean();
    syncDataRequestBean.loginName = Application.user.userCode;
    syncDataRequestBean.password = Application.user.passWord;
    syncDataRequestBean.domainId = "1";
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    syncDataRequestBean.version = packageInfo.version;
    syncDataRequestBean.isGzip = "1";
    return syncDataRequestBean;
  }
}
