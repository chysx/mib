import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:mib/business/delivery_util.dart';
import 'package:mib/business/product_util.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_item_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/ui/dialog/list_dialog.dart';
import 'package:mib/ui/dialog/loading_dialog.dart';
import 'package:mib/ui/dialog/model/key_value_info.dart';
import 'package:mib/ui/page/print/blue_manager.dart';
import 'package:mib/utils/file_util.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';


/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/30 15:33

enum PrintDeliverySlipEvent {
  InitData,
}

class PrintDeliverySlipPresenter extends EventNotifier<PrintDeliverySlipEvent> {
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
  Future onEvent(PrintDeliverySlipEvent event, [dynamic data]) async {
    switch (event) {
      case PrintDeliverySlipEvent.InitData:
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
    address = DeliveryModel().mDeliveryHeader.DeliveryAddress;
    orderNo = DeliveryModel().mDeliveryHeader.OrderNo;
//    phone = DeliveryModel().mDeliveryHeader.DeliveryPhone;
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
    await savePrintPng(rootWidgetKey);
    showBlueDialog(context);
  }

  void showBlueDialog(BuildContext context){
    LoadingDialog.show(context,msg: 'loading...');
    BlueManager().scan((deviceList){
      LoadingDialog.dismiss(context);
      List<KeyValueInfo> list = deviceList.map((device){
        return new KeyValueInfo()
          ..name = device.name
          ..value = device.name
          ..data = device;
      }).toList();

      //添加弹出框消失回调方法
      ListDialog.show(context,title: 'title',data: list,onSelect: (reason) async {
        BluetoothDevice device = reason.data;
        if(Platform.isAndroid){
          BlueManager().sendAddress(device.id.toString());
        }else if(Platform.isIOS){
          BlueManager().sendAddress(device.name);
        }
      });
    });

  }


  Future<Uint8List> savePrintPng(GlobalKey rootWidgetKey) async {
    try {
      RenderRepaintBoundary boundary =
      rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await FileUtil.saveFileData(pngBytes,Constant.WORK_IMG,'print.png');
      return pngBytes;//这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
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
