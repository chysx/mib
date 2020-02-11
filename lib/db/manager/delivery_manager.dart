import 'package:mib/application.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/9/4 14:25

class DeliveryManager {
  static Future insertOrUpdateDeliveryHeader(DSD_T_DeliveryHeader_Entity header) async {
    DSD_T_DeliveryHeader_Entity entity = await Application.database.tDeliveryHeaderDao.findEntityByDeliveryNo(header.DeliveryNo);
    if(entity == null){
      await Application.database.tDeliveryHeaderDao.insertEntity(header);
    }else{
      await Application.database.tDeliveryHeaderDao.updateEntity(header);
    }
  }

  static Future<int> getTotalCount() async {
    List<DSD_T_DeliveryItem_Entity> list = await Application.database.tDeliveryItemDao.findAll();
    return list.length;
  }

  static Future<void> fillItemItemSequence(List<DSD_T_DeliveryItem_Entity> deliveryItemList) async {
    int totalCount = await DeliveryManager.getTotalCount();
    for(DSD_T_DeliveryItem_Entity entity in deliveryItemList) {
      totalCount++;
      entity.ItemSequence = totalCount.toString();
    }
  }

}