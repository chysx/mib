import 'package:mib/common/business_const.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/truck_stock_manager.dart';
import 'package:mib/db/table/entity/dsd_m_shipment_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_shipment_header_entity.dart';
import 'package:mib/db/table/entity/dsd_t_shipment_item_entity.dart';
import 'package:mib/model/stock_info.dart';
import 'package:mib/synchronization/sync/sync_dirty_status.dart';
import 'package:flustars/flustars.dart';
import 'package:uuid/uuid.dart';

import '../application.dart';
import 'base_product_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/16 11:52

class CheckOutAndInModel {
  String _shipmentNo;
  DSD_M_ShipmentHeader_Entity mShipmentHeader;
  DSD_T_ShipmentHeader_Entity shipmentHeader;
  List<DSD_T_ShipmentItem_Entity> shipmentItemList = [];

  String _getActionType(){
    if(this is CheckOutModel){
      return ActionType.CheckOut;
    }else if(this is CheckInModel){
      return ActionType.CheckIn;
    }
    return null;
  }

  String _getShipmentStatus(){
    if(this is CheckOutModel){
      return ShipmentStatus.CHKO;
    }else if(this is CheckInModel){
      return ShipmentStatus.CHKI;
    }
    return null;
  }

  String _getStockTrackingType(){
    if(this is CheckOutModel){
      if(shipmentHeader.ShipmentType == ShipmentType.DELIVERY) return StockTracking.CHKO;
      if(shipmentHeader.ShipmentType == ShipmentType.VANSALES) return StockTracking.CHKO_VASL;
    }else if(this is CheckInModel){
      if(shipmentHeader.ShipmentType == ShipmentType.DELIVERY) return StockTracking.CHKI;
      if(shipmentHeader.ShipmentType == ShipmentType.VANSALES) return StockTracking.CHKI_VASL;
    }
    return null;
  }

  Future initData(String shipmentNo) async {
    _shipmentNo = shipmentNo;
    mShipmentHeader = await Application.database.mShipmentHeaderDao.findEntityByShipmentNo(shipmentNo, Valid.EXIST);
    shipmentHeader =
    await Application.database.tShipmentHeaderDao.findEntityByShipmentNo(shipmentNo, _getActionType());
    if (shipmentHeader != null) {
      shipmentItemList = await Application.database.tShipmentItemDao.findEntityByHeaderId(shipmentHeader.Id);
    }
  }

  void clear() {
    _shipmentNo = null;
    mShipmentHeader = null;
    shipmentHeader = null;
    shipmentItemList.clear();
  }

  void cacheShipmentItemList(List<BaseProductInfo> productList, String productUnitValue,{List<BaseProductInfo> emptyList}){
    String notTime = DateUtil.getDateStrByDateTime(new DateTime.now());

    if(emptyList != null){
      for (BaseProductInfo info in emptyList) {
        if ((info.actualCs??0) != 0) {
          DSD_T_ShipmentItem_Entity add = new DSD_T_ShipmentItem_Entity.Empty();

          add.HeaderId = shipmentHeader.Id;
          add.ProductCode = info.code;
          add.ProductUnit = ProductUnit.CS;

          add.PlanQty = info.plannedCs;
          add.ActualQty = info.actualCs;
          add.DifferenceQty = info.plannedCs - info.actualCs;

          add.DifferenceReason = info.reasonValue;
          add.CreateUser = Application.user.userCode;
          add.CreateTime = notTime;
          add.dirty = SyncDirtyStatus.DEFAULT;

          shipmentItemList.add(add);
        }
      }
    }


    for (BaseProductInfo info in productList) {
//      if (productUnitValue == ProductUnit.CS_EA || productUnitValue == ProductUnit.CS) {
        if ((info.plannedCs??0) != 0 || (info.actualCs??0) != 0) {
          DSD_T_ShipmentItem_Entity add = new DSD_T_ShipmentItem_Entity.Empty();

          add.HeaderId = shipmentHeader.Id;
          add.ProductCode = info.code;
          add.ProductUnit = ProductUnit.CS;

          add.PlanQty = info.plannedCs;
          add.ActualQty = info.actualCs;
          add.DifferenceQty = info.plannedCs - info.actualCs;

          add.DifferenceReason = info.reasonValue;
          add.CreateUser = Application.user.userCode;
          add.CreateTime = notTime;
          add.dirty = SyncDirtyStatus.DEFAULT;

          shipmentItemList.add(add);
        }
//      }

//      if (productUnitValue == ProductUnit.CS_EA || productUnitValue == ProductUnit.EA) {
        if ((info.plannedEa??0) != 0 || (info.actualEa??0) != 0) {
          DSD_T_ShipmentItem_Entity add = new DSD_T_ShipmentItem_Entity.Empty();

          add.HeaderId = shipmentHeader.Id;
          add.ProductCode = info.code;
          add.ProductUnit = ProductUnit.EA;

          add.PlanQty = info.plannedEa;
          add.ActualQty = info.actualEa;
          add.DifferenceQty = info.plannedEa??0 - info.actualEa??0;

          add.DifferenceReason = info.reasonValue;
          add.CreateUser = Application.user.userCode;
          add.CreateTime = notTime;
          add.dirty = SyncDirtyStatus.DEFAULT;

          shipmentItemList.add(add);
        }
//      }
    }
  }

  Future saveShipmentHeader() async {
    if (shipmentHeader == null) {
      String notTime = DateUtil.getDateStrByDateTime(new DateTime.now());
      shipmentHeader = DSD_T_ShipmentHeader_Entity.Empty();
      shipmentHeader
        ..Id = new Uuid().v1()
        ..ShipmentNo = _shipmentNo
        ..ShipmentType = mShipmentHeader.ShipmentType
        ..ShipmentDate = DateUtil.getDateStrByTimeStr(notTime,format: DateFormat.YEAR_MONTH_DAY)
        ..ActionType = _getActionType()
        ..StartTime = notTime
        ..WarehouseCode = mShipmentHeader.WarehouseCode
        ..Driver = Application.user.userCode
        ..TruckId = mShipmentHeader.TruckId
        ..Odometer = 0
        ..CheckerConfirm = 0
        ..CashierConfirm = 0
        ..GKConfirm = 0
        ..CreateUser = Application.user.userCode
        ..CreateTime = notTime
        ..ScanResult = '0'
        ..Manually = '0'
        ..dirty = SyncDirtyStatus.DEFAULT;

      await Application.database.tShipmentHeaderDao.insertEntity(shipmentHeader);
    }
  }

  Future updateShipmentHeader() async {
    shipmentHeader
      ..Status = _getShipmentStatus()
      ..EndTime = DateUtil.getDateStrByDateTime(new DateTime.now());
    await Application.database.tShipmentHeaderDao.updateEntity(shipmentHeader);
  }

  Future saveShipmentItems() async {
    String stockTrackingType = _getStockTrackingType();
    await saveStock(StockType.CANCEL,shipmentHeader,stockTrackingType);
    await Application.database.tShipmentItemDao.deleteByHeaderId(shipmentHeader.Id);

    await Application.database.tShipmentItemDao.insertEntityList(shipmentItemList);
    await saveStock(StockType.DO,shipmentHeader,stockTrackingType);
  }

  static Future saveStock(StockType stockType,DSD_T_ShipmentHeader_Entity shipmentHeader,String stockTrackingType) async {
    if(shipmentHeader == null) return;

    List<DSD_T_ShipmentItem_Entity> shipmentItemList = await Application.database.tShipmentItemDao.findEntityByHeaderId(shipmentHeader.Id);
    Map<String, StockInfo> stockMap = {};
    for (DSD_T_ShipmentItem_Entity item in shipmentItemList) {
      if (!stockMap.containsKey(item.ProductCode)) {
        StockInfo add = new StockInfo();
        add.productCode = item.ProductCode;
        stockMap[add.productCode] = add;
      }

      switch (item.ProductUnit) {
        case ProductUnit.CS:
          stockMap[item.ProductCode].cs = item.ActualQty;
          break;
        case ProductUnit.EA:
          stockMap[item.ProductCode].ea = item.ActualQty;
          break;
      }
    }

    for (String key in stockMap.keys) {
      await TruckStockManager.setStock(
          stockType, stockTrackingType, shipmentHeader.TruckId, shipmentHeader.ShipmentNo, key, stockMap[key].cs, stockMap[key].ea);
    }
  }

}

class CheckOutModel extends CheckOutAndInModel{
  static CheckOutModel _instance;

  CheckOutModel._();

  static CheckOutModel _getInstance() {
    if (_instance == null) {
      _instance = new CheckOutModel._();
    }
    return _instance;
  }

  factory CheckOutModel() => _getInstance();
}

class CheckInModel extends CheckOutAndInModel{
  static CheckInModel _instance;

  CheckInModel._();

  static CheckInModel _getInstance() {
    if (_instance == null) {
      _instance = new CheckInModel._();
    }
    return _instance;
  }

  factory CheckInModel() => _getInstance();
}