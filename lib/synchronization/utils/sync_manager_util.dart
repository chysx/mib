import 'package:mib/application.dart';
import 'package:mib/db/table/sync_upload_entity.dart';
import 'package:mib/model/visit_model.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:mib/synchronization/sync/sync_type.dart';
import 'package:mib/synchronization/utils/sync_sql_util.dart';
import 'package:mib/ui/page/sync/sync_info.dart';

import '../sync_factory.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/28 16:57

class SyncManagerUtil{

   static Future<List<SyncInfo>> getSyncInfoList(SyncType syncType) async {
    List<SyncInfo> syncInfoList = [];
    List<SyncUploadEntity> syncUploadEntityList = await Application.database.syncUploadDao.findEntityByType(syncType.toString());
    for(SyncUploadEntity entity in syncUploadEntityList){
      SyncInfo syncInfo = new SyncInfo();
      syncInfo.name = entity.name;
      syncInfo.status = entity.status;
      if(entity.time != null){
        String hour = entity.time.split(" ")[1];
        syncInfo.time = hour;
      }
      syncInfo.syncMode = SyncFactory.createSyncModel(syncType);
      SyncParameter parameter = new SyncParameter();
      parameter.putUploadName([entity.name]);
      parameter.putUploadUniqueIdValues(SyncSqlUtil.getUniqueIdValuesByString(entity.uniqueIdValues));
      syncInfo.syncMode.syncParameter = parameter;
      syncInfoList.add(syncInfo);
    }
    return syncInfoList;
  }
}