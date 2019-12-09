import 'package:mib/application.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/db/table/entity/dsd_m_delivery_item_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/model/base_product_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-04 14:37

class ProductUtil {
  static Future<List<BaseProductInfo>> mergeTProduct(
      List<DSD_T_DeliveryItem_Entity> tList,
      bool isMergePrice,
      bool isInM) async {
    Map<String, BaseProductInfo> hashMap = {};
    for (DSD_T_DeliveryItem_Entity tItem in tList) {
      if(tItem.IsReturn == IsReturn.TRUE) continue;
      if (int.tryParse(tItem.ActualQty) == 0) continue;

      String code = tItem.ProductCode;
      BaseProductInfo info = hashMap[code];
      if (info == null) {
        info = new BaseProductInfo();
        hashMap[code] = info;
        info.code = code;
        info.name = (await Application.productMap)[code];
        info.isInMDelivery = isInM;
        info.reasonValue = tItem.Reason;
      }

      if (tItem.ProductCode == info.code) {
        if (tItem.ProductUnit == ProductUnit.CS) {
          info.plannedCs = int.tryParse(tItem.PlanQty);
          info.actualCs = int.tryParse(tItem.ActualQty);
          if (isMergePrice) {
            ProductUtil.mergeTPriceCs(info, tItem);
          }
        } else if (tItem.ProductUnit == ProductUnit.EA) {
          info.plannedEa = int.tryParse(tItem.PlanQty);
          info.actualEa = int.tryParse(tItem.ActualQty);
          if (isMergePrice) {
            ProductUtil.mergeTPriceEa(info, tItem);
          }
        }
      }
    }


    if (isMergePrice) {
      for (BaseProductInfo info in hashMap.values) {
        ProductUtil.mergePrice(info);
      }
    }

    List<BaseProductInfo> result = [];
    for(BaseProductInfo info in hashMap.values){
      result.add(info);
    }

    return result;
  }

   static Future<List<BaseProductInfo>> mergeMProduct(List<DSD_M_DeliveryItem_Entity> mList,
       bool isMergePrice,bool isInM) async {
    Map<String,BaseProductInfo> hashMap = {};
    for(DSD_M_DeliveryItem_Entity mItem in mList){
      String code = mItem.ProductCode;
      BaseProductInfo info = hashMap[code];
      if (info == null) {
        info = new BaseProductInfo();
        hashMap[code] = info;
        info.code = code;
        info.name = (await Application.productMap)[code];
        info.isInMDelivery = isInM;
      }

      if (mItem.ProductCode == info.code) {
        if (mItem.ProductUnit == ProductUnit.CS) {
          info.plannedCs = int.tryParse(mItem.PlanQty);
          if (isMergePrice) {
            ProductUtil.mergeMPriceCs(info, mItem);
          }
        } else if (mItem.ProductUnit == ProductUnit.EA) {
          info.plannedEa = int.tryParse(mItem.PlanQty);
          if (isMergePrice) {
            ProductUtil.mergeMPriceEa(info, mItem);
          }
        }
      }

    }

    if (isMergePrice) {
      for (BaseProductInfo info in hashMap.values) {
        ProductUtil.mergePrice(info);
      }
    }

    List<BaseProductInfo> result = [];
    for(BaseProductInfo info in hashMap.values){
      result.add(info);
    }

    return result;
  }

  static void mergeMPriceCs(
      BaseProductInfo info, DSD_M_DeliveryItem_Entity mItem) {
    info.basePriceCs = double.tryParse(mItem.BasePrice);
    info.netPriceCs = double.tryParse(mItem.NetPrice);
    info.discountCs = double.tryParse(mItem.Discount);
    info.taxCs = double.tryParse(mItem.Tax);
    info.depositCs = double.tryParse(mItem.Deposit);
  }

  static void mergeMPriceEa(
      BaseProductInfo info, DSD_M_DeliveryItem_Entity mItem) {
    info.basePriceCs = double.tryParse(mItem.BasePrice);
    info.netPriceEa = double.tryParse(mItem.NetPrice);
    info.discountEa = double.tryParse(mItem.Discount);
    info.taxEa = double.tryParse(mItem.Tax);
    info.depositEa = double.tryParse(mItem.Deposit);
  }

  static void mergeTPriceCs(
      BaseProductInfo info, DSD_T_DeliveryItem_Entity tItem) {
    info.basePriceCs = double.tryParse(tItem.BasePrice);
    info.netPriceCs = double.tryParse(tItem.NetPrice);
    info.discountCs = double.tryParse(tItem.Discount);
    info.taxCs = double.tryParse(tItem.Tax);
    info.depositCs = double.tryParse(tItem.Deposit);
  }

  static void mergeTPriceEa(
      BaseProductInfo info, DSD_T_DeliveryItem_Entity tItem) {
    info.basePriceEa = double.tryParse(tItem.BasePrice);
    info.netPriceEa = double.tryParse(tItem.NetPrice);
    info.discountEa = double.tryParse(tItem.Discount);
    info.taxEa = double.tryParse(tItem.Tax);
    info.depositEa = double.tryParse(tItem.Deposit);
  }

  static void mergePrice(BaseProductInfo info) {
    info.basePrice =
    (info.basePriceCs != null && info.basePriceCs != 0) ?
    info.basePriceCs : info.basePriceEa;

    info.netPrice = info.netPriceCs ?? 0.0 + info.netPriceEa ?? 0;
    info.discount = info.discountCs ?? 0.0 + info.discountEa ?? 0.0;
    info.tax = info.taxCs ?? 0.0 + info.taxEa ?? 0.0;
    info.deposit = info.depositCs ?? 0.0 + info.depositEa ?? 0.0;
  }
}
