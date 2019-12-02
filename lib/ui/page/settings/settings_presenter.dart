import 'package:mib/application.dart';
import 'package:mib/db/manager/app_config_manager.dart';
import 'package:mib/db/table/entity/app_config_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/net/http_config.dart';
import 'package:mib/net/http_service.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';
import 'package:mib/ui/page/settings/setting_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/2 17:54


enum SettingEvent{
  ChangeCheckBox,
  SelectEnv,
  InitData
}

class SettingPresenter extends EventNotifier<SettingEvent>{
  List<SettingInfo> settingList = new List();
  SettingInfo curSettingInfo = new SettingInfo();


  @override
  Future onEvent(SettingEvent event,[dynamic data]) async {
    switch(event){
      case SettingEvent.ChangeCheckBox:
        setCurSsl(data);
        break;
      case SettingEvent.SelectEnv:
        setCurSettingInfo(data);
        break;
      case SettingEvent.InitData:
        await initData();
        break;
    }
    super.onEvent(event,data);
  }

  Future initData() async {
    initSettingList();
    await initCurSettingInfo();
  }

  void initSettingList() {
    settingList.clear();

    SettingInfo devInfo = new SettingInfo();
    devInfo
      ..host = UrlDev.HOST
      ..port = UrlDev.PORT
      ..isSsl = UrlDev.IS_SSL
      ..env = UrlDev.ENV;

    SettingInfo qasInfo = new SettingInfo();
    qasInfo
      ..host = UrlQas.HOST
      ..port = UrlQas.PORT
      ..isSsl = UrlQas.IS_SSL
      ..env = UrlQas.ENV;

    SettingInfo uatInfo = new SettingInfo();
    uatInfo
      ..host = UrlUat.HOST
      ..port = UrlUat.PORT
      ..isSsl = UrlUat.IS_SSL
      ..env = UrlUat.ENV;

    SettingInfo prdInfo = new SettingInfo();
    prdInfo
      ..host = UrlPrd.HOST
      ..port = UrlPrd.PORT
      ..isSsl = UrlPrd.IS_SSL
      ..env = UrlPrd.ENV;

    SettingInfo otherInfo = new SettingInfo();
    otherInfo
      ..host = ''
      ..port = ''
      ..isSsl = false
      ..env = 'OTHER';

    settingList.add(devInfo);
    settingList.add(qasInfo);
    settingList.add(uatInfo);
    settingList.add(prdInfo);
    settingList.add(otherInfo);

  }

  Future initCurSettingInfo() async {
    curSettingInfo = await getCurSettingInfo();
  }

  static Future<SettingInfo> getCurSettingInfo() async {
    SettingInfo curSettingInfo = new SettingInfo();
    List<AppConfigEntity> list = await AppConfigManager.queryAll();
    if(ObjectUtil.isEmptyList(list)){
      UrlConfig config = HttpConfig.urlConfig;
      switch(config){
        case UrlConfig.DEV:
          curSettingInfo
            ..host = UrlDev.HOST
            ..port = UrlDev.PORT
            ..isSsl = UrlDev.IS_SSL
            ..env = UrlDev.ENV;
          break;
        case UrlConfig.QAS:
          curSettingInfo
            ..host = UrlQas.HOST
            ..port = UrlQas.PORT
            ..isSsl = UrlQas.IS_SSL
            ..env = UrlQas.ENV;
          break;
        case UrlConfig.UAT:
          curSettingInfo
            ..host = UrlUat.HOST
            ..port = UrlUat.PORT
            ..isSsl = UrlUat.IS_SSL
            ..env = UrlUat.ENV;
          break;
        case UrlConfig.PRD:
          curSettingInfo
            ..host = UrlPrd.HOST
            ..port = UrlPrd.PORT
            ..isSsl = UrlPrd.IS_SSL
            ..env = UrlPrd.ENV;
          break;
        default:
          curSettingInfo
            ..host = ''
            ..port = ''
            ..isSsl = false
            ..env = 'OTHER';
          break;
      }
    }else{
      AppConfigEntity entity = list[0];
      curSettingInfo
        ..host = entity.host
        ..port = entity.port
        ..isSsl = SettingInfo.strToBool(entity.isSsl)
        ..env = entity.env;
    }

    return curSettingInfo;
  }

  void setCurSettingInfo(String env) {
    for (SettingInfo info in settingList) {
      if (info.env == env) {
        curSettingInfo
          ..host = info.host
          ..port = info.port
          ..isSsl = info.isSsl
          ..env = info.env;
        break;
      }
    }
  }

  void setCurSsl(bool isSsl){
    curSettingInfo.isSsl = isSsl;
  }

  bool isDisable() => curSettingInfo.env != 'OTHER';

  void onClickSave(BuildContext context) {
    CustomerDialog.show(context, msg:'save success',onConfirm: () async {
      await save();
      Navigator.of(context).pop('refresh');
    });
  }

  Future save() async {
    List<AppConfigEntity> list = await AppConfigManager.queryAll();
    AppConfigEntity entity;

    if(ObjectUtil.isEmptyList(list)){
      entity = new AppConfigEntity.Empty();
      entity
        ..env = curSettingInfo.env
        ..host = curSettingInfo.host
        ..port = curSettingInfo.port
        ..isSsl = SettingInfo.boolToStr(curSettingInfo.isSsl)
        ..syncInitFlag = null;
      await AppConfigManager.insert(entity);
    }else{
      entity = list[0];
      entity..env = curSettingInfo.env
        ..host = curSettingInfo.host
        ..port = curSettingInfo.port
        ..isSsl = SettingInfo.boolToStr(curSettingInfo.isSsl)
        ..syncInitFlag = null;
      await AppConfigManager.update(entity);
    }
    resetUrlConfig(curSettingInfo);
  }

  static void resetUrlConfig(SettingInfo settingInfo){
    if(settingInfo.env == UrlDev.ENV){
      HttpConfig.urlConfig = UrlConfig.DEV;
    }else if(settingInfo.env == UrlQas.ENV){
      HttpConfig.urlConfig = UrlConfig.QAS;
    }else if(settingInfo.env == UrlUat.ENV){
      HttpConfig.urlConfig = UrlConfig.UAT;
    }else if(settingInfo.env == UrlPrd.ENV){
      HttpConfig.urlConfig = UrlConfig.PRD;
    }
    HttpService().resetConfigDio();
  }

}
