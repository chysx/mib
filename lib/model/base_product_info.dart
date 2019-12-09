import 'package:mib/common/business_const.dart';
import 'package:mib/common/dictionary.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/9/16 14:26

class BaseProductInfo {
   String code;
   String name;
   int plannedCs = 0;
   int plannedEa = 0;
   int actualCs = 0;
   int actualEa = 0;
   String itmNumberCs;
   String itmNumberEa;
   String desc;
   String reasonValue;
  //该产品code是否存在DSD_M_DeliveryItem表中
   bool isInMDelivery;
   bool isCheck = false;


   double basePrice = 0.0;
   double basePriceCs = 0.0;
   double basePriceEa = 0.0;
   double netPrice = 0.0;
   double netPriceCs = 0.0;
   double netPriceEa = 0.0;
   double discount = 0.0;
   double discountCs = 0.0;
   double discountEa = 0.0;
   double tax = 0.0;
   double taxCs = 0.0;
   double taxEa = 0.0;
   double deposit = 0.0;
   double depositCs = 0.0;
   double depositEa = 0.0;



    String getPlanShowStr(String productUnitValue){
      if(productUnitValue == ProductUnit.CS_EA){
         return '$plannedCs/$plannedEa';
      }else if (productUnitValue == ProductUnit.CS){
         return plannedCs.toString();
      }else if (productUnitValue == ProductUnit.EA){
         return plannedEa.toString();
      }
      return '$plannedCs/$plannedEa';
   }

    String getActualShowStr(String productUnitValue){
      if(productUnitValue == ProductUnit.CS_EA){
         return '$actualCs/$actualEa';
      }else if (productUnitValue == ProductUnit.CS){
         return actualCs.toString();
      }else if (productUnitValue == ProductUnit.EA){
         return actualEa.toString();
      }
      return '$actualCs/$actualEa';
   }

    String getPlanShowStrByType(String taskType){
      if(taskType == TaskType.EmptyReturn){
         return plannedCs.toString();
      }
      return '$plannedCs/$plannedEa';
   }

    String getActualShowStrByType(String taskType){
      if(taskType == TaskType.EmptyReturn){
         return actualCs.toString();
      }
      return '$actualCs/$actualEa';
   }

   bool isEqual(){
      return (plannedCs ?? 0) == (actualCs ?? 0) && (plannedEa ?? 0) == (actualEa ?? 0);
   }

   bool isRedReasonIcon(){
      return (reasonValue ?? '').isEmpty;
   }

   bool isPass(){
      return isEqual() || !isRedReasonIcon();
   }

   static String getActualTotal(List<BaseProductInfo> productList){
     int totalCs = 0;
     int totalEa = 0;
     for(BaseProductInfo info in productList){
       totalCs += info.actualCs ?? 0;
       totalEa += info.actualEa ?? 0;
     }
     return '$totalCs/$totalEa';
   }

   static String getPlanTotal(List<BaseProductInfo> productList){
     int totalCs = 0;
     int totalEa = 0;
     for(BaseProductInfo info in productList){
       totalCs += info.plannedCs;
       totalEa += info.plannedEa;
     }
     return '$totalCs/$totalEa';
   }

}