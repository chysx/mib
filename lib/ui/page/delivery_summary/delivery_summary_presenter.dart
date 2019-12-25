import 'package:fluttertoast/fluttertoast.dart';
import 'package:mib/application.dart';
import 'package:mib/business/delivery_util.dart';
import 'package:mib/business/product_util.dart';
import 'package:mib/business/signature/delivery_signature.dart';
import 'package:mib/business/signature/signature_logic.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:flutter/material.dart';
import 'package:mib/price/price_convert_util.dart';
import 'package:mib/price/price_manager.dart';
import 'package:mib/utils/number_util.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/9/18 10:29

enum DeliverySummaryEvent {
  InitData,
  RefreshPrice
}

class DeliverySummaryPresenter extends EventNotifier<DeliverySummaryEvent> {
  DSD_T_DeliveryHeader_Entity deliveryHeader;
  List<BaseProductInfo> productList = [];
  List<BaseProductInfo> emptyProductList = [];
  String deliveryNo;
  String shipmentNo;
  String accountNumber;
  String customerName;
  String deliveryType;
  String productUnitValue;
  bool isReadOnly;

  bool isDoPrice = false;

  @override
  Future onEvent(DeliverySummaryEvent event, [dynamic data]) async {
    switch (event) {
      case DeliverySummaryEvent.InitData:
        await initData(data);
        break;

      case DeliverySummaryEvent.RefreshPrice:
        await fillProductData();
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
    this.isReadOnly = bundle[FragmentArg.DELIVERY_SUMMARY_READONLY] == ReadyOnly.TRUE;
  }

  Future initData(BuildContext context) async {
    if(!DeliveryModel().isInitData()){
      await DeliveryModel().initData(deliveryNo);
    }
    initDoPrice();
    await fillProductData();
    fillProductPrice();
    await fillEmptyProductData();

    if(isDoPrice){
      priceCalculate(context);
    }

  }

  initDoPrice() {
    if(isReadOnly) return;

    List<DSD_T_DeliveryItem_Entity> tList = DeliveryModel().deliveryItemList;
    isDoPrice = tList.any((item){
      return item.IsReturn == IsReturn.TRUE || item.PlanQty != item.ActualQty;
    });
  }

  Future fillProductData() async {
    productList.clear();

    List<DSD_T_DeliveryItem_Entity> tList = DeliveryModel().deliveryItemList;
    productList.addAll(await ProductUtil.mergeTProduct(tList, true, true));
  }

  fillProductPrice() {
    DeliveryModel().cacheDeliveryHeaderPriceByM();
    deliveryHeader = DeliveryModel().deliveryHeader;
  }

  Future fillEmptyProductData() async {
    emptyProductList.clear();

    emptyProductList.addAll(await DeliveryUtil.createEmptyProductList(DeliveryModel().deliveryItemList));
  }

  bool isHideNextButton() {
//    return VisitManager.isVisitCompleteByVisit(VisitModel().visit);
    return isReadOnly;
  }

  Future onClickRight(BuildContext context) async {
//    await saveData();
//    Navigator.of(context).pop();
//    Navigator.of(context).pop();
      showSignature(context);
  }

  void showSignature(BuildContext context) {
    new DeliverySignature(
        accountNumber: accountNumber,
        onSuccess: (_,info) async {
          if(info.role == Role.driver){
            print('onSuccess: ${info.name} ${info.code} \n${info.signatureName}');

            DeliveryModel().cacheDeliveryHeaderCustomerSignature(info.signatureName);

            await saveData();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

          }else {
            DeliveryModel().cacheDeliveryHeaderDriverSignature(info.signatureName);
          }
        },
        onFail: (_,info){
          print('onFail');
          if(info.role == Role.driver){
            print('onSuccess: ${info.name} ${info.code} \n${info.signatureName}');

          }else {

          }
        }
    ).show(context);
  }

  Future saveData() async {
    await DeliveryModel().saveDeliveryHeader();
    await DeliveryModel().saveDeliveryItems();
  }

  String get2Decimal() {
    return NumberUtil.get2Decimal(12.999);
  }

  priceCalculate(BuildContext context) {
    PriceManager.start(context: context,
      onSuccessSync: (result){
        Fluttertoast.showToast(msg: 'Successed');
        PriceConvertUtil.onlineToDelivery(result, DeliveryModel().deliveryHeader, DeliveryModel().deliveryItemList);
        onEvent(DeliverySummaryEvent.RefreshPrice);
        },
      onFailSync: (e){
        Fluttertoast.showToast(msg: 'Calculation falied please calculate again,check network or contact administrattor.');
    });
  }




  @override
  void dispose() {
    if(isReadOnly) {
      DeliveryModel().clear();
      print('****************dispose:DeliveryModel().clear()**********************');
    }
    super.dispose();
  }

}
