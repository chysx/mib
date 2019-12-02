import 'package:mib/synchronization/base/abstract_sync_mode.dart';
import 'package:mib/synchronization/sync/sync_status.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/28 16:53

class SyncInfo {
   String name;
   String status;
   String time;
   AbstractSyncMode syncMode;

   String getStatusMsg(){
    if(status == SyncStatus.SYNC_SUCCESS.toString()){
      return "Success";
    }else if(status == SyncStatus.SYNC_LOAD.toString()){
      return "Loading";
    }else{
      return "Fail";
    }
  }
}