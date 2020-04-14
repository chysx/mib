import 'package:fluttertoast/fluttertoast.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/model/check_out_and_in_model.dart';
import 'package:mib/route/page_builder.dart';
import 'package:flutter/material.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:mib/synchronization/sync/sync_type.dart';
import 'package:mib/synchronization/sync_manager.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/12 16:21

enum CheckInEvent {
  InitData
}

class CheckInPresenter extends EventNotifier<CheckInEvent> {
  String shipmentNo;

  @override
  void onEvent(CheckInEvent event, [dynamic data]) async {
    switch (event) {
      case CheckInEvent.InitData:
        await initData();
        break;
    }

    super.onEvent(event, data);
  }

  void setBundle(Map<String,dynamic> bundle){
    shipmentNo = bundle[FragmentArg.ROUTE_SHIPMENT_NO];
  }

  Future initData() async {
    await CheckInModel().initData(shipmentNo);
  }

  bool isComplete(){
//    return CheckInModel().shipmentItemList.length > 0;
    return CheckInModel().shipmentHeader?.ActionType != null;
  }

  String getIsCompleteText() {
    if(isComplete()){
      return 'Completed';
    }
    return 'Not Completed';
  }

  Future onClickItem(BuildContext context,String shipmentNo) async {
    if(isComplete()){
      Fluttertoast.showToast(msg: 'You already complete the inventory');
      return;
    }
    Map<String,dynamic> bundle = {
      FragmentArg.ROUTE_SHIPMENT_NO: shipmentNo,
    };
    await Navigator.pushNamed(context, PageName.check_in_inventory.toString(),arguments: bundle);

    onResume();
  }

  void onResume(){
    onEvent(CheckInEvent.InitData);
  }


  bool isPass() {
    return isComplete();
  }

  Future<void> onClickRight(BuildContext context) async {
    if (isPass()) {
      await CheckInModel().updateShipmentHeader();
      uploadData(context);
    }else{
      CustomerDialog.show(context, msg: 'You must complete the inventory count.');
    }

  }


  void uploadData(BuildContext context) {
    SyncParameter syncParameter = new SyncParameter();
    syncParameter.putUploadUniqueIdValues([shipmentNo]).putUploadName([shipmentNo]);

    SyncManager.start(SyncType.SYNC_UPLOAD_CHECKIN, context: context,syncParameter: syncParameter, onSuccessSync: () {
      Navigator.of(context).pop();
    }, onFailSync: (e) async {
      CustomerDialog.show(context, msg: 'upload fail', onConfirm: () {
        Navigator.of(context).pop();
      }, onCancel: () {
        Navigator.of(context).pop();
      });
    });
  }


}