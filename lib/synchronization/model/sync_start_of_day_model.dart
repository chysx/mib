import 'package:mib/synchronization/base/abstract_sync_upload_model.dart';
import 'package:mib/synchronization/bean/table_uploade_bean.dart';
import 'package:mib/synchronization/sql/startofday_model_sql_find.dart';
import 'package:mib/synchronization/sql/startofday_model_sql_update.dart';
import 'package:mib/synchronization/sync/sync_call_back.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:mib/synchronization/sync/sync_type.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 18:21

class SyncStartOfDayModel extends AbstractSyncUploadModel {
  SyncStartOfDayModel(SyncType syncType,
      {SyncParameter syncParameter, OnSuccessSync onSuccessSync, OnFailSync onFailSync})
      : super(syncType, syncParameter: syncParameter, onSuccessSync: onSuccessSync, onFailSync: onFailSync);

  @override
  List<TableUploadBean> getTableUploadList() {
    List<TableUploadBean> uploadBeanList = [];

    TableUploadBean dayTimer = new TableUploadBean('DSD_T_DayTimeTracking',
        StartOfDayModelSqlFind.DSD_T_DayTimeTracking_Sql_Find,
        StartOfDayModelSqlUpdate.DSD_T_DayTimeTracking_Sql_Update, getUploadUniqueIdValues());

    TableUploadBean truckCheck = new TableUploadBean('DSD_T_TruckCheckResult',
        StartOfDayModelSqlFind.DSD_T_TruckCheckResult_Sql_Find,
        StartOfDayModelSqlUpdate.DSD_T_TruckCheckResult_Sql_Update, getUploadUniqueIdValues());


    uploadBeanList.add(dayTimer);
    uploadBeanList.add(truckCheck);

    return uploadBeanList;
  }
}