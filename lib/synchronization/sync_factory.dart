import 'package:mib/synchronization/model/sync_update_model.dart';
import 'package:mib/synchronization/model/sync_upload_checkin_model.dart';
import 'package:mib/synchronization/model/sync_upload_checkout_model.dart';
import 'package:mib/synchronization/model/sync_upload_visit_model.dart';
import 'package:mib/synchronization/sync/sync_type.dart';

import 'base/abstract_sync_mode.dart';
import 'model/sync_init_model.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/9/19 10:47

class SyncFactory {
  static AbstractSyncMode createSyncModel(SyncType syncType) {
    AbstractSyncMode syncMode;
    switch (syncType) {
      case SyncType.SYNC_INIT:
        syncMode = new SyncInitModel(syncType);
        break;
      case SyncType.SYNC_UPDATE:
        syncMode = new SyncUpdateModel(syncType);
        break;
      case SyncType.SYNC_UPLOAD_CHECKOUT:
        syncMode = new SyncUploadCheckOutModel(syncType);
        break;
      case SyncType.SYNC_UPLOAD_CHECKIN:
        syncMode = new SyncUploadCheckInModel(syncType);
        break;
      case SyncType.SYNC_UPLOAD_VISIT:
        syncMode = new SyncUploadVisitModel(syncType);
        break;
      default:
        break;
    }
    return syncMode;
  }
}