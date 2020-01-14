import 'package:flustars/flustars.dart';
import 'package:mib/application.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/model/base_product_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-11 11:41

class DeliveryUtil {
  static Future<List<BaseProductInfo>> createEmptyProductList(List<DSD_T_DeliveryItem_Entity> tList) async {
    List<BaseProductInfo> result = [];
    for (DSD_T_DeliveryItem_Entity tItem in tList) {
      if(tItem.IsReturn != IsReturn.TRUE) continue;
      if (int.tryParse(tItem.ActualQty) == 0) continue;

      BaseProductInfo info = new BaseProductInfo();
      info.code = tItem.ProductCode;
      info.name = (await Application.productMap)[tItem.ProductCode];
      info.actualCs = int.tryParse(tItem.ActualQty);
      result.add(info);
    }
    return result;
  }

  ///
  /// 创建deliveryNo
  /// @param accountNumber 门店编号
  /// @return
  ///
  static String createDeliveryNo(String accountNumber){
    String monthDay = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.MONTH_DAY).replaceAll('-', '');
    String hms = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.HOUR_MINUTE_SECOND).replaceAll(':', '');

    return '$accountNumber$monthDay$hms';
  }

}