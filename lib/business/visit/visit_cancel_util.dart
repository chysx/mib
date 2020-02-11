import 'package:mib/application.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/delivery_manager.dart';
import 'package:mib/db/table/entity/dsd_m_delivery_item_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/synchronization/sync/sync_dirty_status.dart';
import 'package:flustars/flustars.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/28 15:01

class VisitCancelUtil {
  static saveData(DSD_T_DeliveryHeader_Entity header,List<DSD_T_DeliveryItem_Entity> tItemList) async {
    DeliveryModel().clear();
    await DeliveryModel().initData(header.DeliveryNo);
    DeliveryModel().deliveryHeader = header;
    DeliveryModel().deliveryItemList = tItemList;
    await DeliveryModel().saveDeliveryHeader();
    DeliveryManager.fillItemItemSequence(tItemList);
    await DeliveryModel().saveDeliveryItems();
    DeliveryModel().clear();
  }

  static Future<List<DSD_T_DeliveryItem_Entity>> copyDeliveryItemM2T(DSD_T_DeliveryHeader_Entity header,String reasonValue) async {
    List<DSD_M_DeliveryItem_Entity> list = await Application.database.mDeliveryItemDao.findEntityByDeliveryNo(header.DeliveryNo);
    List<DSD_T_DeliveryItem_Entity> tItemList = [];
    for (DSD_M_DeliveryItem_Entity entity in list) {
      if(header.DeliveryType == TaskType.Delivery){
        DSD_T_DeliveryItem_Entity addEntity = new DSD_T_DeliveryItem_Entity.Empty();
        addEntity.DeliveryNo = header.DeliveryNo;
        addEntity.ProductCode = entity.ProductCode;
        addEntity.ProductUnit = entity.ProductUnit;
        addEntity.PlanQty = entity.PlanQty;
        addEntity.ActualQty = "0";
        addEntity.CreateUser = Application.user.userCode;
        addEntity.CreateTime = DateUtil.getDateStrByDateTime(new DateTime.now());
        addEntity.dirty = SyncDirtyStatus.DEFAULT;
        addEntity.IsFree = entity.IsFree;
        addEntity.Reason = reasonValue;
        addEntity.ItemNumber = entity.ItemNumber;
        addEntity.ItemCategory = entity.ItemCategory;

        tItemList.add(addEntity);
      }
    }
    return tItemList;
  }
}