import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:mib/application.dart';
import 'package:mib/business/signature/start_of_day_signature.dart';
import 'package:mib/business/signature/signature_util.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/manager/shipment_manager.dart';
import 'package:mib/db/table/entity/dsd_m_truck_entity.dart';
import 'package:mib/db/table/entity/dsd_m_truckchecklist_entity.dart';
import 'package:mib/db/table/entity/dsd_t_daytimetracking_entity.dart';
import 'package:mib/db/table/entity/dsd_t_truckcheckresult_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/synchronization/sync/sync_dirty_status.dart';
import 'package:mib/synchronization/sync/sync_parameter.dart';
import 'package:mib/synchronization/sync/sync_type.dart';
import 'package:mib/synchronization/sync_manager.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';
import 'package:mib/ui/widget/bool_choice_widget.dart';
import 'package:mib/ui/widget/multi_choice_widget.dart';
import 'package:mib/ui/widget/single_choice_widget.dart';
import 'package:uuid/uuid.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-11 17:32

enum StartOfDayEvent { InitData }

class StartOfDayPresenter extends EventNotifier<StartOfDayEvent> {
  Map<String,List<DSD_T_TruckCheckResult_Entity>> resultMap = {};
  DSD_T_DayTimeTracking_Entity dayTimeEntity = new DSD_T_DayTimeTracking_Entity.Empty();
  List<Widget> widgetList = [];
  int shipmentCount = 0;
  int customerCount = 0;

  @override
  Future onEvent(StartOfDayEvent event, [dynamic data]) async {
    switch (event) {
      case StartOfDayEvent.InitData:
        await initData();
        break;
    }
    super.onEvent(event, data);
  }

  Future initData() async {
    await fillShipmentCount();
    await fillCustomerCount();
    await fillTruckList();
  }

  Future fillShipmentCount() async {
    shipmentCount = (await ShipmentManager.getShipmentList()).length;
  }

  Future fillCustomerCount() async {
    customerCount = await ShipmentManager.getCustomerList();
  }

  Future fillTruckList() async {

    resultMap.clear();

    List<DSD_M_TruckCheckList_Entity> rootTruckCheckAskList =
        await Application.database.mCheckListDao.findEntityByParentId('0');

    int index = 0;
    int totalAns = 0;
    for (DSD_M_TruckCheckList_Entity rootTruckCheckAsk in rootTruckCheckAskList) {

      //rootTruckCheckAsk.getChilds():车辆检查问题（Ask）列表(例如：Ask1?;Ask2?;Ask3?)
      List<DSD_M_TruckCheckList_Entity> list =
      await Application.database.mCheckListDao.findEntityByParentId(rootTruckCheckAsk.Id.toString());

      for (DSD_M_TruckCheckList_Entity askEntity in list) {
        List<DSD_M_TruckCheckList_Entity> childList =
        await Application.database.mCheckListDao.findEntityByParentId(askEntity.Id.toString());

        index++;
        //entity:具体问题（Ask）(例如：Ask1?)
        if (askEntity.InputType == CheckType.BOOLE) {
          widgetList.add(BoolChoiceWidget(askEntity,index,totalAns,(info,totalIndex){
            int checkItemId = askEntity.Id;
            DSD_T_TruckCheckResult_Entity resultEntity = new DSD_T_TruckCheckResult_Entity.Empty();
            resultEntity.DetailNo = totalIndex;
            resultEntity.CheckItemId = checkItemId;
            resultEntity.CheckResult = info;

            resultMap[checkItemId.toString()] = [resultEntity];
          }));
        } else if (askEntity.InputType == CheckType.SINGLESELECT) {

          widgetList.add(SingleChoiceWidget(askEntity,childList,index,totalAns,(info,totalIndex){
            int checkItemId = askEntity.Id;
            DSD_T_TruckCheckResult_Entity resultEntity = new DSD_T_TruckCheckResult_Entity.Empty();
            resultEntity.DetailNo = totalIndex;
            resultEntity.CheckItemId = checkItemId;
            resultEntity.CheckResult = info.Content;

            resultMap[checkItemId.toString()] = [resultEntity];
          }));

        } else if (askEntity.InputType == CheckType.MULTISELECT) {
          widgetList.add(MultiChoiceWidget(askEntity,childList,index,totalAns,(infoList,totalIndexMap){
            int checkItemId = askEntity.Id;
            List<DSD_T_TruckCheckResult_Entity> resultEntityList = [];
            for(DSD_M_TruckCheckList_Entity item in infoList){
              DSD_T_TruckCheckResult_Entity resultEntity = new DSD_T_TruckCheckResult_Entity.Empty();
              resultEntity.DetailNo = totalIndexMap[item.Id];
              resultEntity.CheckItemId = checkItemId;
              resultEntity.CheckResult = item.Content;

              resultEntityList.add(resultEntity);
            }

            resultMap[checkItemId.toString()] = resultEntityList;
          }));
        }
        totalAns += childList.length;
      }
    }
  }


  Future saveData() async {
    List<DSD_T_TruckCheckResult_Entity> resultList = [];
    String createTime = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL);

    String uuid = Uuid().v1();

    createDayTimeEntity();
    dayTimeEntity.ID = uuid;
    dayTimeEntity.CreateTime = createTime;
    dayTimeEntity.Dirty = SyncDirtyStatus.DEFAULT;
    await Application.database.dayTimeTrackDao.insertEntity(dayTimeEntity);

    for(List<DSD_T_TruckCheckResult_Entity> entityList in resultMap.values){
      for(DSD_T_TruckCheckResult_Entity entity in entityList){
        entity.CreateTime = createTime;
        entity.DayTrackingId = uuid;
        entity.Dirty = SyncDirtyStatus.DEFAULT;
      }
      resultList.addAll(entityList);
    }
    await Application.database.tCheckResultDao.insertEntityList(resultList);
  }

  Future createDayTimeEntity() async {
    List<DSD_M_Truck_Entity> truckEntityList = await Application.database.mTruckDao.findAll();

    DSD_M_Truck_Entity truckEntity = DSD_M_Truck_Entity.Empty();
    if(truckEntityList.length > 0) truckEntity = truckEntityList[0];

    String time = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL);
    String day = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.YEAR_MONTH_DAY);
    dayTimeEntity.TrackingTime = time;
    dayTimeEntity.WorkDate = day;
    dayTimeEntity.UserCode = Application.user.userCode;
    dayTimeEntity.TrackingType = TimeTrackingType.SOD;
    dayTimeEntity.TruckId = truckEntity.ID;
//    dayTimeEntity.Odometer = 0;

  }

  void onClickSign(BuildContext context) {
    new StartOfDaySignature(
        onSuccess: (_,info) async {
          print('onSuccess');
          dayTimeEntity.Signature = SignatureUtil.SUCCESS;
        },
        onFail: (_,info){
          print('onFail');
          dayTimeEntity.Signature = '';
          dayTimeEntity.SignImg = '';
        }
    ).showByDriverSignOff(context);
  }

  Future<void> onClickStart(BuildContext context) async {
    if(! await isPass()) return;

    await saveData();
    uploadData(context);
  }

  Future<bool> isPass() async {
    if(await isNotDoneMustToDo()) return false;
    if(!isDoneSign()) return false;
    return true;
  }

  Future<bool> isNotDoneMustToDo() async {
    List<DSD_M_TruckCheckList_Entity> rootTruckCheckAskList =
        await Application.database.mCheckListDao.findEntityByParentId('0');
    for(DSD_M_TruckCheckList_Entity rootTruckCheckAsk in rootTruckCheckAskList){
      List<DSD_M_TruckCheckList_Entity> list =
      await Application.database.mCheckListDao.findEntityByParentId(rootTruckCheckAsk.Id.toString());
      for(DSD_M_TruckCheckList_Entity askEntity in list) {
        if(askEntity.MustToDo == MustToDo.TRUE){
          if(!resultMap.keys.contains(askEntity.Id)){
            return true;
          }
        }
      }
    }

    return false;
  }

  bool isDoneSign() {
    return dayTimeEntity.Signature == SignatureUtil.SUCCESS;
  }

  void uploadData(BuildContext context) {
    SyncParameter syncParameter = new SyncParameter();
    syncParameter.putUploadUniqueIdValues([dayTimeEntity.ID]).putUploadName(['start of day']);

    SyncManager.start(SyncType.SYNC_UPLOAD_START_OF_DAY, context: context,syncParameter: syncParameter, onSuccessSync: () {
      startCheckout(context);
    }, onFailSync: (e) async {
      CustomerDialog.show(context, msg: 'upload fail', onConfirm: () {
        startCheckout(context);
      }, onCancel: () {
        startCheckout(context);
      });
    });
  }


  void startCheckout(BuildContext context) async {
    Map<String,dynamic> bundle = {};
    Navigator.pushReplacementNamed(context, PageName.check_out_shipment.toString(),arguments: bundle);

  }


}
