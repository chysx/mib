import 'package:mib/application.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/reason_manager.dart';
import 'package:mib/db/manager/shipment_manager.dart';
import 'package:mib/db/table/entity/dsd_t_shipment_item_entity.dart';
import 'package:mib/db/table/entity/md_product_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/check_out_and_in_model.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';
import 'package:mib/ui/dialog/list_dialog.dart';
import 'package:mib/ui/dialog/model/key_value_info.dart';
import 'package:flutter/material.dart';


/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/12 16:21

enum CheckInInventoryEvent {
  InitData,
  SelectOrCancelAll,
  SelectOrCancelEmptyAll,
  OnInput,
}

class CheckInInventoryPresenter extends EventNotifier<CheckInInventoryEvent> {
  List<BaseProductInfo> productList = [];
  List<BaseProductInfo> emptyProductList = [];
  List<KeyValueInfo> reasonList = [];
  String shipmentNo;
  String productUnitValue;

  @override
  void onEvent(CheckInInventoryEvent event, [dynamic data]) async {
    switch (event) {
      case CheckInInventoryEvent.InitData:
        await initData();
        break;
      case CheckInInventoryEvent.SelectOrCancelAll:
        selectOrCancelAll(productList,data);
        break;
      case CheckInInventoryEvent.SelectOrCancelEmptyAll:
        selectOrCancelAll(emptyProductList,data);
        break;
      case CheckInInventoryEvent.OnInput:
        onInput(data);
        break;
    }

    super.onEvent(event, data);
  }


  void setBundle(Map<String,dynamic> bundle){
    shipmentNo = bundle[FragmentArg.ROUTE_SHIPMENT_NO];
  }

  Future initData() async {
    //默认CSEA都显示
    productUnitValue = ProductUnit.CS_EA;
    await fillProductData();
    await fillEmptyProductData();
    await fillReasonData();
  }

  Future<void> fillProductData() async {
    List<DSD_T_ShipmentItem_Entity> tList = CheckInModel().shipmentItemList;
    productList = await ShipmentManager.getShipmentItemProductStockByNo(shipmentNo);

    for(BaseProductInfo info in productList){
      for (DSD_T_ShipmentItem_Entity tItem in tList) {
        if (info.code == tItem.ProductCode && tItem.ProductUnit == ProductUnit.CS) {
          info.actualCs = tItem.ActualQty;
          info.reasonValue = tItem.DifferenceReason;
        }else if (info.code == tItem.ProductCode && tItem.ProductUnit == ProductUnit.EA) {
          info.actualEa = tItem.ActualQty;
          info.reasonValue = tItem.DifferenceReason;
        }
      }
    }

  }

  Future<void> fillEmptyProductData() async {
    emptyProductList.clear();

    List<MD_Product_Entity> list = await Application.database.productDao.findEntityByEmpty(Empty.TRUE);
    List<BaseProductInfo> stockProductList = await ShipmentManager.getEmptyProductByShipmentNo(shipmentNo);
    for(MD_Product_Entity entity in list){
      BaseProductInfo info = new BaseProductInfo();
      info.code = entity.ProductCode;
      info.name = entity.Name;
      for(BaseProductInfo stock in stockProductList){
        if(entity.ProductCode == stock.code){
          info.plannedCs = stock.plannedCs;
        }
      }
      emptyProductList.add(info);
    }
  }

  Future fillReasonData() async {
    reasonList = await ReasonManager.getReasonData(CheckInDiffReason.CATEGORY);
  }

  void showReasonDialog(BuildContext context,BaseProductInfo info){
    ListDialog.show(context,title: 'title',data: reasonList,onSelect: (reason){
      info.reasonValue = reason.value;
      notifyListeners();
    });
  }

  void selectOrCancelAll(List<BaseProductInfo> productList,bool isCheck){
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

  onInput(BaseProductInfo info){
    info.isCheck = info.plannedCs == info.actualCs && info.plannedEa == info.actualEa;
  }

  onClickRight(BuildContext context) async {
    if(isPass()){
      await saveData();
      Navigator.of(context).pop();
    }else{
      CustomerDialog.show(context,msg: 'Please select a difference reason.');
    }
  }

  bool isPass(){
    for(BaseProductInfo info in productList){
      if(!info.isPass()) return false;
    }

    for(BaseProductInfo info in emptyProductList){
      if(!info.isPass()) return false;
    }
    return true;
  }

  Future saveData() async {
    await CheckInModel().saveShipmentHeader();
    CheckInModel().cacheShipmentItemList(productList, productUnitValue,emptyList: emptyProductList);
    await CheckInModel().saveShipmentItems();
  }

}