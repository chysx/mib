import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/price/price_response_bean.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-10 17:32

class PriceConvertUtil {
  static onlineToDelivery(PriceResponseBean result,DSD_T_DeliveryHeader_Entity tHeader,List<DSD_T_DeliveryItem_Entity> tItemList) {

    tHeader
        ..BasePrice = result.data.basePrice.toString()
        ..NetPrice = result.data.netPrice.toString()
        ..Discount = result.data.subTotalOfDiscounts.toString()
        ..Tax = result.data.outputTax.toString()
        ..Deposit = result.data.depositFee.toString();

    for (Product product in result.data.products){
      for (DSD_T_DeliveryItem_Entity tItem in tItemList) {
        if(tItem.ProductCode == product.productRecordRef){

          tItem
            ..BasePrice = product.totalBasePrice.toString()
            ..NetPrice = product.netPrice.toString()
            ..Discount = product.subTotalOfDiscounts.toString()
            ..Tax = product.tax.toString()
            ..Deposit = '';

        }
      }

    }


  }
}