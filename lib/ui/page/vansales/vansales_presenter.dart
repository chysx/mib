import 'package:flutter/material.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/truck_stock_manager.dart';
import 'package:mib/db/table/entity/md_product_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/model/visit_model.dart';
import 'package:mib/route/page_builder.dart';

import '../../../application.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-13 11:21

enum VanSalesEvent {
  InitData,
  OnInput,
  SelectOrCancelAll,
  SelectOrCancelEmptyAll,
  SelectOrCancel
}

class VanSalesPresenter extends EventNotifier<VanSalesEvent> {
  List<BaseProductInfo> productList = [];
  List<BaseProductInfo> emptyProductList = [];

  String shipmentNo;
  String accountNumber;
  String deliveryNo;
  String deliveryType;
  String customerName;

  @override
  void onEvent(VanSalesEvent event, [dynamic data]) async {
    switch (event) {
      case VanSalesEvent.InitData:
        await initData();
        break;
      case VanSalesEvent.OnInput:
        BaseProductInfo.onInput(data);
        break;
      case VanSalesEvent.SelectOrCancelAll:
        BaseProductInfo.selectOrCancelAll(productList, data);
        break;
      case VanSalesEvent.SelectOrCancelEmptyAll:
        BaseProductInfo.selectOrCancelAll(emptyProductList, data);
        break;
      case VanSalesEvent.SelectOrCancel:
        BaseProductInfo.selectOrCancel(data);
        break;
    }
    super.onEvent(event, data);
  }

  void setBundle(Map<String, dynamic> bundle) {
    deliveryNo = bundle[FragmentArg.DELIVERY_NO];
    shipmentNo = bundle[FragmentArg.DELIVERY_SHIPMENT_NO];
    accountNumber = bundle[FragmentArg.DELIVERY_ACCOUNT_NUMBER];
    customerName = bundle[FragmentArg.TASK_CUSTOMER_NAME];
    deliveryType = bundle[FragmentArg.DELIVERY_TYPE];
  }

  Future initData() async {
    await DeliveryModel().initData(deliveryNo);
    await fillProductData();
    await fillEmptyProductData();
  }

  Future<void> fillProductData() async {
    productList = await TruckStockManager.getStock(shipmentNo);
  }


  Future fillEmptyProductData() async {
    emptyProductList.clear();
    List<MD_Product_Entity> list = await Application.database.productDao.findEntityByEmpty(Empty.TRUE);
    for (MD_Product_Entity product in list) {
      BaseProductInfo info = new BaseProductInfo();
      info.code = product.ProductCode;
      info.name = product.Name;
      emptyProductList.add(info);
    }
  }

  void onClickRight(BuildContext context) {
    cacheData();
    Map<String,dynamic> bundle = {
      FragmentArg.DELIVERY_NO: deliveryNo,
      FragmentArg.DELIVERY_SHIPMENT_NO: shipmentNo,
      FragmentArg.DELIVERY_ACCOUNT_NUMBER: accountNumber,
      FragmentArg.TASK_CUSTOMER_NAME: customerName,
      FragmentArg.DELIVERY_TYPE: deliveryType,
      FragmentArg.DELIVERY_SUMMARY_READONLY: false,
    };
    Navigator.pushNamed(context, PageName.van_sales_summary.toString(),arguments: bundle);

  }


  void cacheData() {
    DeliveryModel().cacheDeliveryHeader(
        visitId: VisitModel().visit.VisitId,
        shipmentNo: shipmentNo,
        accountNumber: accountNumber,
        deliveryType: deliveryType,
        deliveryStatus: DeliveryStatus.SALES_VALUE);
    DeliveryModel().cacheDeliveryItemList(productList, ProductUnit.CS_EA,emptyList: emptyProductList);
  }

  @override
  void dispose() {
    DeliveryModel().clear();
    print('****************dispose:DeliveryModel().clear()**********************');
    super.dispose();
  }

}