import 'package:flutter/material.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/route_manager.dart';
import 'package:mib/db/manager/shipment_manager.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/shipment_info.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/ui/page/route/customer_info.dart';
import 'package:mib/utils/number_util.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 16:03

enum DailyEvent {
  InitData,
  SelectShipment
}

class ShipmentCustomer {
  int visitedCount;
  int totalCount;

  String getShowStr() {
    return NumberUtil.get2Decimal(visitedCount * 100.0 / totalCount);
  }
}

class DailyPresenter extends EventNotifier<DailyEvent> {
  List<ShipmentInfo> shipmentList = [];
  ShipmentInfo currentShipment;
  Map<String, ShipmentCustomer> map = {};


  @override
  Future onEvent(DailyEvent event, [dynamic data]) async {
    switch (event) {
      case DailyEvent.InitData:
        await initData();
        break;
      case DailyEvent.SelectShipment:
        setCurShipmentBySelected(data);
        break;
    }
    super.onEvent(event, data);
  }


  Future initData() async {
    await fillShipmentData();
    await fillShipmentCustomerData();
    fillCurShipment();
  }

  Future fillShipmentData() async {
    shipmentList = await ShipmentManager.getShipmentHeaderByCheckOutAndIn();
    shipmentList.sort((ShipmentInfo si1, ShipmentInfo si2) {
      int result = si2.shipmentDate.compareTo(si1.shipmentDate);
      return result == 0 ? si1.sequence.compareTo(si2.sequence) : result;
    });
  }

  fillShipmentCustomerData() async {
    for (ShipmentInfo shipmentInfo in shipmentList) {
      List<CustomerInfo> list;
      if(shipmentInfo.type == ShipmentType.DELIVERY){
        list = await RouteManager.getCustomerInfoListByDelivery(shipmentInfo.no);
      }else if(shipmentInfo.type == ShipmentType.VANSALES){
        list = await RouteManager.getCustomerInfoListByVanSales(shipmentInfo.no);
      }

      int count = 0;
      for (CustomerInfo info in list) {
        if (info.isVisitComplete) {
          count++;
        }
      }
      ShipmentCustomer shipmentCustomer = new ShipmentCustomer();
      shipmentCustomer.visitedCount = count;
      shipmentCustomer.totalCount = list.length;
      map[shipmentInfo.no] = shipmentCustomer;
    }
  }

  void fillCurShipment() {
    if(shipmentList.length > 0){
      currentShipment = shipmentList[0];
    }
  }

  void setCurShipmentBySelected(String shipmentNo) {
    currentShipment = shipmentList.firstWhere((info){
      return info.no == shipmentNo;
    });
  }

  void onClickRight(BuildContext context) {
    Map<String,dynamic> bundle = {FragmentArg.TASK_SHIPMENT_NO: currentShipment.no};
    Navigator.pushReplacementNamed(context, PageName.inventory.toString(),arguments: bundle);

  }

}