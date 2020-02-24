import 'package:flutter/material.dart';
import 'package:mib/application.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/table/entity/dsd_t_shipment_header_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/utils/sql_util.dart';

import 'model/inventory_detail_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 16:03

enum InventoryEvent {
  InitData,
}

class InventoryPresenter extends EventNotifier<InventoryEvent> {
  String shipmentNo;
  List<String> rowHeaderList = [];
  List<String> columnHeaderList = [];
  List<List<String>> data = [];

  @override
  Future onEvent(InventoryEvent event, [dynamic data]) async {
    switch (event) {
      case InventoryEvent.InitData:
        await initData();
        break;
    }
    super.onEvent(event, data);
  }

  void setBundle(Map<String, dynamic> bundle) {
    shipmentNo = bundle[FragmentArg.TASK_SHIPMENT_NO];
  }


  Future initData() async {
    await fillInventoryData();
    fillColumnHeaderData();
  }


  Future<void> fillInventoryData() async {
    Map<String, InventoryDetailInfo> hashMap = {};

    await fillCheckOutData(hashMap);
    await fillStockData(hashMap);
    await fillDeliveryData(hashMap);

    for (InventoryDetailInfo info in hashMap.values) {
      List<String> list = [
//        '${info.productCode} ${info.productName}',
        '${info.stockCs??0}/${info.stockEa??0}',
        '${(info.saleableCs??0) > 0 ? info.saleableCs : 0}/${(info.saleableEa??0) > 0
            ? info.saleableEa : 0}',
        '${info.checkoutCs??0}/${info.checkoutEa??0}',
        '${info.deliveryCs??0}/${info.deliveryEa??0}',
        '${info.tradeReturnCs??0}/${info.tradeReturnEa??0}',
        '${info.emptyReturnCs??0}/${info.emptyReturnEa??0}',
        '${info.vanSalesCs??0}/${info.vanSalesEa??0}'

      ];
      data.add(list);
      rowHeaderList.add('${info.productCode} ${info.productName}');
    }

    addTotal(hashMap);

  }

  void addTotal(Map<String,InventoryDetailInfo> hashMap) {
    InventoryDetailInfo tempTotal = new InventoryDetailInfo();
    for (InventoryDetailInfo info in hashMap.values) {
      tempTotal.stockCs += info.stockCs;
      tempTotal.stockEa += info.stockEa;
      tempTotal.saleableCs += info.saleableCs;
      tempTotal.saleableEa += info.saleableEa;
      tempTotal.checkoutCs += info.checkoutCs;
      tempTotal.checkoutEa += info.checkoutEa;
      tempTotal.deliveryCs += info.deliveryCs;
      tempTotal.deliveryEa += info.deliveryEa;
      tempTotal.tradeReturnCs += info.tradeReturnCs;
      tempTotal.tradeReturnEa += info.tradeReturnEa;
      tempTotal.emptyReturnCs += info.emptyReturnCs;
      tempTotal.emptyReturnEa += info.emptyReturnEa;
      tempTotal.vanSalesCs += info.vanSalesCs;
      tempTotal.vanSalesEa += info.vanSalesEa;
    }
    List<String> totalList = [
      '${tempTotal.stockCs??0}/${tempTotal.stockEa??0}',
      '${(tempTotal.saleableCs??0) > 0 ? tempTotal.saleableCs : 0}/${(tempTotal.saleableEa??0) > 0
          ? tempTotal.saleableEa : 0}',
      '${tempTotal.checkoutCs??0}/${tempTotal.checkoutEa??0}',
      '${tempTotal.deliveryCs??0}/${tempTotal.deliveryEa??0}',
      '${tempTotal.tradeReturnCs??0}/${tempTotal.tradeReturnEa??0}',
      '${tempTotal.emptyReturnCs??0}/${tempTotal.emptyReturnEa??0}',
      '${tempTotal.vanSalesCs??0}/${tempTotal.vanSalesEa??0}'
    ];
    data.add(totalList);
    rowHeaderList.add('Total');
  }

  void fillColumnHeaderData() {
    columnHeaderList = [
//      "Poduct/SKU",
      "Stock",
      "Saleable",
      "Checkout",
      "Delivery",
      "Trade Return",
      "Empty Return",
      "Van Sales"
    ];
  }


  Future fillCheckOutData(Map<String,InventoryDetailInfo> hashMap) async {
//    DSD_T_ShipmentHeader_Entity tShipmentHeader =
//    await Application.database.tShipmentHeaderDao.findEntityByShipmentNo(shipmentNo, ActionType.CheckOut);

    String sql = ''' 
      SELECT
            t1.productcode,
            t2.name,
            t1.actualqty,
            t1.productunit,
            t2.ebmobile__pack__c 
        FROM
            dsd_t_shipmentitem t1          
        INNER JOIN
            md_product AS t2            
                ON t1.productcode = t2.productcode 
        WHERE
            t1.headerid = ? 
        ORDER BY
            t2.ebmobile__pack__c ASC,
            t1.productcode ASC
     ''';

    SqlUtil.log(sql, [/*tShipmentHeader.Id*/'12878c60-43d0-11ea-b807-335b42570614']);
    var db = Application.database.database;
    List<Map<String, dynamic>> list = await db.rawQuery(sql, [/*tShipmentHeader.Id*/'12878c60-43d0-11ea-b807-335b42570614']);
    for (Map<String, dynamic> map in list) {
      List values = map.values.toList();

      InventoryDetailInfo info;
      String code = values[0];
      if(hashMap[code] == null){
        info = new InventoryDetailInfo();
        hashMap[code] = info;
      }else {
        info = hashMap[code];
      }
      info.productCode = values[0];
      info.productName = values[1];
      String productUnit = values[3];
      info.productUnit = productUnit;
      if(productUnit == ProductUnit.CS) {
        info.checkoutCs = values[2];
      }else if(productUnit == ProductUnit.EA) {
        info.checkoutEa = values[2];
      }
      info.pack = values[4];
    }
  }

  Future fillStockData(Map<String,InventoryDetailInfo> hashMap) async {

    String sql = ''' 
        SELECT
            t1.productcode,
            t2.name,
            t1.stockqty,
            t1.saleableqty,
            t1.productunit,
            t2.ebmobile__pack__c 
        FROM
            dsd_t_truckstock t1          
        INNER JOIN
            md_product AS t2            
                ON t1.productcode = t2.productcode 
        WHERE
            shipmentno = ? 
        ORDER BY
            t2.ebmobile__pack__c ASC,
            t1.productcode ASC
     ''';

    SqlUtil.log(sql, [shipmentNo]);
    var db = Application.database.database;
    List<Map<String, dynamic>> list = await db.rawQuery(sql, [shipmentNo]);
    for (Map<String, dynamic> map in list) {
      List values = map.values.toList();

      InventoryDetailInfo info;
      String code = values[0];
      if(hashMap[code] == null){
        info = new InventoryDetailInfo();
        hashMap[code] = info;
      }else {
        info = hashMap[code];
      }
      info.productCode = values[0];
      info.productName = values[1];
      String productUnit = values[4];
      info.productUnit = productUnit;
      if(productUnit == ProductUnit.CS) {
        info.stockCs = values[2];
        info.saleableCs = values[3];
      }else if(productUnit == ProductUnit.EA) {
        info.stockEa = values[2];
        info.saleableEa = values[3];
      }
      info.pack = values[5];
    }
  }

  Future fillDeliveryData(Map<String,InventoryDetailInfo> hashMap) async {

    String sql = ''' 
        SELECT
            t1.productcode,
            t3.name,
            t1.actualqty,
            t1.productunit,
            t2.deliverytype,
            t3.ebmobile__pack__c 
        FROM
            dsd_t_deliveryitem t1          
        INNER JOIN
            dsd_t_deliveryheader t2            
                ON t1.deliveryno = t2.deliveryno          
        INNER JOIN
            md_product AS t3            
                ON t1.productcode = t3.productcode 
        WHERE
            t2.shipmentno = ? 
        ORDER BY
            t3.ebmobile__pack__c ASC,
            t1.productcode ASC
     ''';

    SqlUtil.log(sql, [shipmentNo]);
    var db = Application.database.database;
    List<Map<String, dynamic>> list = await db.rawQuery(sql, [shipmentNo]);
    for (Map<String, dynamic> map in list) {
      List values = map.values.toList();

      InventoryDetailInfo info;
      String code = values[0];
      if(hashMap[code] == null){
        info = new InventoryDetailInfo();
        hashMap[code] = info;
      }else {
        info = hashMap[code];
      }
      info.productCode = values[0];
      info.productName = values[1];
      String productUnit = values[3];
      info.productUnit = productUnit;
      String deliveryType = values[4];
      if(productUnit == ProductUnit.CS){
        if(deliveryType == TaskType.Delivery){
          info.deliveryCs = int.tryParse(values[2]);
        }else if(deliveryType == TaskType.TradeReturn){
          info.tradeReturnCs = int.tryParse(values[2]);
        }else if(deliveryType == TaskType.EmptyReturn){
          info.emptyReturnCs = int.tryParse(values[2]);
        }else if(deliveryType == TaskType.VanSales){
          info.vanSalesCs = int.tryParse(values[2]);
        }
      }else if(productUnit == ProductUnit.EA){
        if(deliveryType == TaskType.Delivery){
          info.deliveryEa = int.tryParse(values[2]);
        }else if(deliveryType == TaskType.TradeReturn){
          info.tradeReturnEa = int.tryParse(values[2]);
        }else if(deliveryType == TaskType.EmptyReturn){
          info.emptyReturnEa = int.tryParse(values[2]);
        }else if(deliveryType == TaskType.VanSales){
          info.vanSalesEa = int.tryParse(values[2] as String);
        }
      }
      info.pack = values[5];
    }
  }



  void onClickRight(BuildContext context) {
    Map<String,dynamic> bundle = {};
    Navigator.pushReplacementNamed(context, PageName.daily.toString(),arguments: bundle);

  }

}