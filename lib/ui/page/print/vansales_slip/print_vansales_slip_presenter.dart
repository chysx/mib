import 'dart:typed_data';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:mib/business/delivery_util.dart';
import 'package:mib/business/product_util.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/ui/page/print/print_util.dart';
import 'package:mib/utils/file_util.dart';

import '../blue_manager.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-14 12:00

enum PrintVanSalesSlipEvent {
  InitData,
}

class PrintVanSalesSlipPresenter extends EventNotifier<PrintVanSalesSlipEvent> {
  List<BaseProductInfo> productList = [];
  List<BaseProductInfo> emptyProductList = [];
  TotalBaseProductInfo totalInfo = new TotalBaseProductInfo();
  DSD_T_DeliveryHeader_Entity deliveryHeader;
  String shipmentNo;
  String accountNumber;
  String customerName;
  String deliveryNo;

  String address;
  String orderNo;
  String phone;
  String data;


  @override
  Future onEvent(PrintVanSalesSlipEvent event, [dynamic data]) async {
    switch (event) {
      case PrintVanSalesSlipEvent.InitData:
        await initData();
        break;
    }
    super.onEvent(event, data);
  }

  void setBundle(Map<String,dynamic> bundle){
    deliveryNo = bundle[FragmentArg.DELIVERY_NO];
    shipmentNo = bundle[FragmentArg.DELIVERY_SHIPMENT_NO];
    accountNumber = bundle[FragmentArg.DELIVERY_ACCOUNT_NUMBER];
    customerName = bundle[FragmentArg.TASK_CUSTOMER_NAME];
  }

  Future initData() async {
    await DeliveryModel().initData(deliveryNo);
    deliveryHeader = DeliveryModel().deliveryHeader;
    await fillProductData();
    await fillEmptyProductData();
    fillTotalBaseProductInfo();
    phone = '';
    data = DateUtil.getDateStrByDateTime(DateTime.now());
  }

  Future fillProductData() async {
    productList.clear();

    List<DSD_T_DeliveryItem_Entity> tList = DeliveryModel().deliveryItemList;
    productList.addAll(await ProductUtil.mergeTProduct(tList, true, true));

  }

  Future fillEmptyProductData() async {
    emptyProductList.clear();

    emptyProductList.addAll(await DeliveryUtil.createEmptyProductList(DeliveryModel().deliveryItemList));
  }

  fillTotalBaseProductInfo() {
    totalInfo = BaseProductInfo.getTotalBaseProductInfo(productList);
  }

  Future onClickRight(BuildContext context,GlobalKey rootWidgetKey) async {
    await PrintUtil.savePrintPng(rootWidgetKey);
    PrintUtil.showBlueDialog(context);
  }


  Uint8List getCustomerSign() {
    return FileUtil.readFileData(Constant.WORK_IMG, DeliveryModel().deliveryHeader.CustomerSignImg);
  }

  Uint8List getDriverSign() {
    return FileUtil.readFileData(Constant.WORK_IMG, DeliveryModel().deliveryHeader.DriverSignImg);
  }

  @override
  void dispose() {
    BlueManager().cancel();
    DeliveryModel().clear();
    print('****************dispose:DeliveryModel().clear()**********************');
    super.dispose();
  }
}
