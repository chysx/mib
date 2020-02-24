/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-18 14:24

class InventoryDetailInfo {
  String pack;
  String productName;
  String productCode;
  int stockCs = 0;
  int stockEa = 0;
  int saleableCs = 0;
  int saleableEa = 0;
  int checkoutCs = 0;
  int checkoutEa = 0;
  int deliveryCs = 0;
  int deliveryEa = 0;
  int tradeReturnCs = 0;
  int tradeReturnEa = 0;
  int emptyReturnCs = 0;
  int emptyReturnEa = 0;
  int vanSalesCs = 0;
  int vanSalesEa = 0;

  String productUnit;

  String getValueByColumn(int column){
    if(column == 0){
      return "$productCode $productName";
    }else if(column == 1){
      return "$stockCs/$stockEa";
    }else if(column == 2){
      return  "${saleableCs > 0 ? saleableCs : 0}/${saleableEa > 0 ? saleableEa : 0}";
    }else if(column == 3){
      return "$checkoutCs/$checkoutEa";
    }else if(column == 4){
      return "$deliveryCs/$deliveryEa";
    }else if(column == 5){
      return "$tradeReturnCs/$tradeReturnEa";
    }else if(column == 6){
      return "$emptyReturnCs/$emptyReturnEa";
    }else if(column == 7){
      return "$vanSalesCs/$vanSalesEa";
    }
    return "";
  }
}