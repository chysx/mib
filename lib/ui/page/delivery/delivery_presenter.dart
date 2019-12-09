import 'package:mib/application.dart';
import 'package:mib/business/product_util.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/common/system_config.dart';
import 'package:mib/db/manager/system_config_manager.dart';
import 'package:mib/db/manager/truck_stock_manager.dart';
import 'package:mib/db/table/entity/dsd_m_delivery_item_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/db/table/entity/md_product_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/model/truck_stock_product_info.dart';
import 'package:mib/model/visit_model.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/route/routers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/9/16 12:06

enum DeliveryEvent {
  InitData,
  OnInput,
}

class DeliveryPresenter extends EventNotifier<DeliveryEvent> {
  List<BaseProductInfo> productList = [];
  List<BaseProductInfo> emptyProductList = [];
  List<TruckStockProductInfo> stockList = [];
  String deliveryNo;
  String shipmentNo;
  String accountNumber;
  String customerName;
  String deliveryType;
  String productUnitValue;
  bool isHold;

  @override
  Future onEvent(DeliveryEvent event, [dynamic data]) async {
    switch (event) {
      case DeliveryEvent.InitData:
        await initData();
        break;
      case DeliveryEvent.OnInput:
        onInput(data);
        break;
    }
    super.onEvent(event, data);
  }

  void setBundle(Map<String,dynamic> bundle){
    deliveryNo = bundle[FragmentArg.DELIVERY_NO];
    shipmentNo = bundle[FragmentArg.DELIVERY_SHIPMENT_NO];
    accountNumber = bundle[FragmentArg.DELIVERY_ACCOUNT_NUMBER];
    customerName = bundle[FragmentArg.TASK_CUSTOMER_NAME];
    deliveryType = bundle[FragmentArg.DELIVERY_TYPE];
  }

  Future initData() async {
    await DeliveryModel().initData(deliveryNo);
    await initConfig();
    await fillProductData();
    await fillEmptyProductData();
    await fillStockData();
  }

  Future initConfig() async {
    String productUnit = await SystemManager.getSystemConfigValue(Delivery.CATEGORY, Delivery.PRODUCT_UNIT);
    switch (productUnit) {
      case ProductUnit.CS_EA_VALUE:
        productUnitValue = ProductUnit.CS_EA;
        break;
      case ProductUnit.CS_VALUE:
        productUnitValue = ProductUnit.CS;
        break;
      case ProductUnit.EA_VALUE:
        productUnitValue = ProductUnit.EA;
        break;
    }

  }

  Future fillProductData() async {
    productList.clear();

    List<DSD_M_DeliveryItem_Entity> mList =
    await Application.database.mDeliveryItemDao.findEntityByDeliveryNo(deliveryNo);
    productList.addAll(await ProductUtil.mergeMProduct(mList, true,true));

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

  ///
  /// 设置初始化库存
  ///
  Future fillStockData() async {
    stockList = await TruckStockManager.getProductStock(this.shipmentNo);
    for (BaseProductInfo item in productList) {
      for (TruckStockProductInfo stock in stockList) {
        if (stock.productCode == item.code) {
          stock.csStockQty += item.actualCs;
          stock.eaStockQty += item.actualEa;
        }
      }
    }
  }

  void selectOrCancelAll(bool isCheck){
    for(BaseProductInfo info in productList){
      info.isCheck = isCheck;
      info.actualCs = info.plannedCs;
      info.actualEa = info.plannedEa;
    }
  }

  void selectOrCancel(BaseProductInfo info,bool isCheck){
    info.isCheck = isCheck;
    if(isCheck){
      info.actualCs = info.plannedCs;
      info.actualEa = info.plannedEa;
    }
    notifyListeners();
  }


  onInput(BaseProductInfo info) {
    info.isCheck = info.plannedCs == info.actualCs && info.plannedEa == info.actualEa;
  }

  void cacheData() {
    DeliveryModel().cacheDeliveryHeader(
        visitId: VisitModel().visit.VisitId,
        shipmentNo: shipmentNo,
        accountNumber: accountNumber,
        deliveryType: deliveryType,
        deliveryStatus: getDeliveryStatus());
    DeliveryModel().cacheDeliveryItemList(productList, productUnitValue,emptyList: emptyProductList);
  }

  ///
  /// 缓存DeliveryHeader数据
  ///
  String getDeliveryStatus() {
    bool isEqual = true;
    for (BaseProductInfo item in productList) {
      if (!item.isEqual()) {
        isEqual = false;
        break;
      }
    }

    return isEqual ? DeliveryStatus.TOTAL_DELIVERED_VALUE : DeliveryStatus.PARTIAL_DELIVERED_VALUE;
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
    Navigator.pushNamed(context, PageName.delivery_summary.toString(),arguments: bundle);

  }

  @override
  void dispose() {
    DeliveryModel().clear();
    print('****************dispose:DeliveryModel().clear()**********************');
    super.dispose();
  }

}
