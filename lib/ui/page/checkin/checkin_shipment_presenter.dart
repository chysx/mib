import 'package:fluttertoast/fluttertoast.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/reason_manager.dart';
import 'package:mib/db/manager/route_manager.dart';
import 'package:mib/db/manager/shipment_manager.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/shipment_info.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/route/routers.dart';
import 'package:mib/synchronization/base/abstract_sync_mode.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:mib/synchronization/sync/sync_type.dart';
import 'package:mib/synchronization/sync_factory.dart';
import 'package:mib/synchronization/sync_manager.dart';
import 'package:mib/synchronization/utils/sync_manager_util.dart';
import 'package:mib/ui/dialog/checkin_cancel_dialog.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';
import 'package:mib/ui/dialog/model/key_value_info.dart';
import 'package:mib/ui/page/route/customer_info.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../../../application.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/12 15:46

enum CheckInShipmentEvent {
  InitData,
}

class ShipmentCustomer {
  int visitedCount;
  int totalCount;
  List<CustomerInfo> customerList;//未上传的门店

  isAllVisited() {
    return visitedCount == totalCount;
  }

  String getShowStr() {
    return '$visitedCount/$totalCount';
  }
}

class CheckInShipmentPresenter extends EventNotifier<CheckInShipmentEvent> {
  List<ShipmentInfo> shipmentInfoList = [];
  Map<String, ShipmentCustomer> map = {};
  List<KeyValueInfo> reasonList = [];
  ShipmentInfo shipmentInfo;

  @override
  void onEvent(CheckInShipmentEvent event, [dynamic data]) async {
    switch (event) {
      case CheckInShipmentEvent.InitData:
        await initData();
        break;
    }

    super.onEvent(event, data);
  }

  Future initData() async {
    await fillShipmentData();
    await fillShipmentCustomerData();
    await fillReasonData();
  }

  Future fillShipmentData() async {
    shipmentInfoList = await ShipmentManager.getShipmentHeaderByCheckOutAndIn();
    shipmentInfoList.sort((ShipmentInfo si1, ShipmentInfo si2) {
      int result = si2.shipmentDate.compareTo(si1.shipmentDate);
      return result == 0 ? si1.sequence.compareTo(si2.sequence) : result;
    });
  }

  fillShipmentCustomerData() async {
    for (ShipmentInfo shipmentInfo in shipmentInfoList) {
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
      shipmentCustomer.customerList = list.where((customer){
        return !customer.isVisitComplete;
      }).toList();
      map[shipmentInfo.no] = shipmentCustomer;
    }
  }

  Future fillReasonData() async {
    reasonList.clear();
    reasonList.addAll(await ReasonManager.getReasonData(CheckInNoAction.CATEGORY));
    reasonList.addAll(await ReasonManager.getReasonData(CancelDelReasonExZF61.CATEGORY));
  }

  String getShipmentCustomerStatusStr(ShipmentInfo shipmentInfo){
    return map[shipmentInfo.no].getShowStr();
  }

  Future<void> onClickItem(BuildContext context, ShipmentInfo info) async {
    this.shipmentInfo = info;
    if(!map[info.no].isAllVisited()){
//      CustomerDialog.show(context,msg: 'Please upload all customer data first');
      CheckInCancelDialog.show(context,
          title: 'NO VISIT REASON',
        customerList: map[shipmentInfo.no].customerList,
        reasonList: reasonList,
        onConfirm: (info) async {
          if(info.value == CheckInNoAction.NA){
            if(await SyncManagerUtil.isHasFailSyncEntity()){
              await uploadAllData(context,true);
            }else{
              await cancelCheckIn(context);
            }
            return ;
          }
          await cancelVisits(context,info);
        },
        onCancel: (){},
      );
      return;
    }else {
      if (await SyncManagerUtil.isHasFailSyncEntity()) {
        await uploadAllData(context,false);
      }
    }

    if(info.status == ShipmentStatus.CHKI){
      CustomerDialog.show(context,msg: 'This shipment had checked in');
      return;
    }

    await startCheckInPage(context);

  }

  Future<void> startCheckInPage(BuildContext context,) async {
    Map<String, dynamic> bundle = {
      FragmentArg.ROUTE_SHIPMENT_NO: shipmentInfo.no,
    };

    await Navigator.pushNamed(context, PageName.check_in.toString(),
        arguments: bundle);

    onResume();
  }

  Future<void> cancelVisits(BuildContext context,KeyValueInfo selectReasonInfo) async {
    List<String> visitIdList = await makeCanCelVisitData(selectReasonInfo);
    uploadVisitData(context, visitIdList);
  }

  void uploadVisitData(BuildContext context,List<String> visitIdList) {
    int index = 0;
    List<AbstractSyncMode> syncModeList = visitIdList.map((visitId){

      AbstractSyncMode syncMode = SyncFactory.createSyncModel(SyncType.SYNC_UPLOAD_VISIT);
      SyncParameter parameter = new SyncParameter();
      parameter
          .putUploadUniqueIdValues([visitId])
          .putUploadName([map[shipmentInfo.no].customerList[index].accountNumber]);
      syncMode.syncParameter = parameter;

      index++;
      return syncMode;

    }).toList();

    SyncManager.startAll(syncModeList, context: context,
        onSuccessSync: () async {
          Fluttertoast.showToast(msg: "The data upload success.");

          if(await SyncManagerUtil.isHasFailSyncEntity()){
            uploadAllData(context,false);
          }else{
            startCheckInPage(context);
          }
        },
        onFailSync: (e) {
          Fluttertoast.showToast(msg: "The data upload failed.");
          CustomerDialog.show(context,msg: 'Couldn\'t check In without upload delivery data,check your network connectivity and try again.',
              onConfirm:(){
                uploadAllData(context,false);
              }
          );
        });

  }

  Future<List<String>> makeCanCelVisitData(KeyValueInfo selectReasonInfo) async {
    List<String> visitIdList = [];
    for(CustomerInfo info in map[shipmentInfo.no].customerList){
      String visitId;
      if(info.customerType == CustomerType.Delivery) {
        visitId = await RouteManager.updateDeliveryStatusCancel(shipmentInfo.no, info.accountNumber, info.cancelReason);
      }else if(info.customerType == CustomerType.VanSales) {
        visitId = await RouteManager.updateVanSalesStatusCancel(shipmentInfo.no, info.accountNumber, info.cancelReason);
      }

      info.cancelReason = selectReasonInfo.value;
      info.status = DeliveryStatus.CANCEL;
      visitIdList.add(visitId);
    }
    return visitIdList;
  }

  Future<void> uploadAllData(BuildContext context,bool isNeedCheckIn) async {
    List<AbstractSyncMode> syncModeList = await SyncManagerUtil.getAllSyncModel();

    SyncManager.startAll(syncModeList, context: context,
        onSuccessSync: () async {
          Fluttertoast.showToast(msg: "The data upload success.");
          if(isNeedCheckIn) {
            await cancelCheckIn(context);
          }else{
            startCheckInPage(context);
          }
        },
        onFailSync: (e) {
          Fluttertoast.showToast(msg: "The data upload failed.");
          CustomerDialog.show(context,msg: 'Couldn\'t check In without upload delivery data,check your network connectivity and try again.',
          onConfirm:(){
            uploadAllData(context,isNeedCheckIn);
          }
          );
        });
  }

  Future<void> cancelCheckIn(BuildContext context) async {
    await ShipmentManager.cancelCheckIn(shipmentInfo.no);
    uploadCheckInData(context);
  }

  void uploadCheckInData(BuildContext context) {
    SyncParameter syncParameter = new SyncParameter();
    syncParameter.putUploadUniqueIdValues([shipmentInfo.no]).putUploadName([shipmentInfo.no]);

    SyncManager.start(SyncType.SYNC_UPLOAD_CHECKIN, context: context,syncParameter: syncParameter,
        onSuccessSync: () {
      Navigator.of(context).pop();
    }, onFailSync: (e) async {
      CustomerDialog.show(context, msg: 'Data upload failed，check your network connectivity and try again.',
          onConfirm: () {
            uploadCheckInData(context);
          }
      );
    });
  }

  void onResume(){
    onEvent(CheckInShipmentEvent.InitData);
  }
}
