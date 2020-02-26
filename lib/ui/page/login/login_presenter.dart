import 'package:mib/application.dart';
import 'package:mib/db/manager/app_config_manager.dart';
import 'package:mib/db/manager/app_log_manager.dart';
import 'package:mib/db/table/entity/app_config_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/exception/exception_type.dart';
import 'package:mib/net/api_service.dart';
import 'package:mib/net/http_config.dart';
import 'package:mib/net/http_service.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/synchronization/sync/sync_type.dart';
import 'package:mib/synchronization/sync_manager.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';
import 'package:mib/ui/dialog/loading_dialog.dart';
import 'package:mib/ui/page/login/login_input_info.dart';
import 'package:mib/ui/page/login/login_request_bean.dart';
import 'package:mib/ui/page/login/login_status.dart';
import 'package:mib/ui/page/settings/setting_info.dart';
import 'package:mib/ui/page/settings/settings_presenter.dart';
import 'package:mib/utils/device_info.dart';
import 'package:mib/utils/string_util.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'login_response_bean.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/2 11:00

enum LoginEvent { InitData }

class LoginPresenter extends EventNotifier<LoginEvent> {
  LoginInputInfo inputInfo = new LoginInputInfo();
  AppConfigEntity appConfigEntity;

  @override
  void onEvent(LoginEvent event, [dynamic data]) async {
    switch (event) {
      case LoginEvent.InitData:
        await initData();
        break;
    }

    super.onEvent(event, data);
  }

  Future initData() async {
    await fillAppConfigEntity();
    initUrlConfig();
  }


  void initUrlConfig() {
    if(appConfigEntity != null){

      switch(appConfigEntity.env){
        case UrlDev.ENV:
          HttpConfig.urlConfig = UrlConfig.DEV;
          break;
        case UrlQas.ENV:
          HttpConfig.urlConfig = UrlConfig.QAS;
          break;
        case UrlUat.ENV:
          HttpConfig.urlConfig = UrlConfig.UAT;
          break;
        case UrlPrd.ENV:
          HttpConfig.urlConfig = UrlConfig.PRD;
          break;
      }

      HttpService().resetConfigDio();
    }
  }

  Future fillAppConfigEntity() async {
    List<AppConfigEntity> list = await Application.database.appConfigDao.findAll();
    if (!ObjectUtil.isEmptyList(list)) {
      appConfigEntity = list[0];
      Application.logger.i('appConfigEntity = ${appConfigEntity.toString()}');
      fillInputData();
      fillAppUser();
    }
  }

  void fillInputData() {
      inputInfo.userCode = appConfigEntity.userCode;
  }

  void fillAppUser() {
    Application.user.userCode = appConfigEntity.userCode;
    Application.user.userName = appConfigEntity.userName;
    Application.user.passWord = appConfigEntity.password;
  }

  Future login(BuildContext context, LoginInputInfo loginInputInfo) async {
    print(loginInputInfo.toString());
    LoginStatus loginStatus = checkLoginInput(loginInputInfo);
    print('*******************status = ${loginStatus.toString()}');
    switch (loginStatus) {
      case LoginStatus.CheckUserCodeIsNull:
        CustomerDialog.show(context, msg: 'Please input your account.');
        break;
      case LoginStatus.CheckPasswordIsNull:
        CustomerDialog.show(context, msg: 'Please input your password!');
        break;
      case LoginStatus.SyncUpdate:
        loginByOnline(context, SyncType.SYNC_UPDATE, loginInputInfo);
        break;
      case LoginStatus.SyncInit:
        loginByOnline(context, SyncType.SYNC_INIT, loginInputInfo);
        break;
      case LoginStatus.OffLine:
        onClickCheckout(context);
        break;
      default:
    }
  }

  Future onClickCheckout(BuildContext context) async {
    Map<String,dynamic> bundle = {};
    await Navigator.pushNamed(context, PageName.check_out_shipment.toString(),arguments: bundle);

//    Map<String,dynamic> bundle = {};
//    await Navigator.pushNamed(context, PageName.start_of_day.toString(),arguments: bundle);

  }


  Future<void> onClickStartOfDay(BuildContext context) async {
    Map<String,dynamic> bundle = {};
    await Navigator.pushNamed(context, PageName.start_of_day.toString(),arguments: bundle);

  }

  Future onClickSetting(BuildContext context) async {
    Map<String,dynamic> bundle = {};
    var result = await Navigator.pushNamed(context, PageName.settings.toString(),arguments: bundle);

    if(result == 'refresh'){
      fillAppConfigEntity();
    }
  }

  LoginStatus checkLoginInput(LoginInputInfo loginInputInfo) {
    if (StringUtil.isEmpty(loginInputInfo.userCode)) return LoginStatus.CheckUserCodeIsNull;

    if (StringUtil.isEmpty(loginInputInfo.password)) return LoginStatus.CheckPasswordIsNull;

    if (appConfigEntity == null ||
        StringUtil.isEmpty(appConfigEntity.userCode) ||
        StringUtil.isEmpty(appConfigEntity.password) ||
        !StringUtil.equalsIgnoreCase(loginInputInfo.userCode, appConfigEntity.userCode) ||
        !StringUtil.equalsIgnoreCase(loginInputInfo.password, appConfigEntity.password)) {
      return LoginStatus.SyncInit;
    }

    if (StringUtil.isEmpty(appConfigEntity.syncInitFlag)) return LoginStatus.SyncInit;

    int lastDay = DateUtil.getDateTime(appConfigEntity.lastUpdateTime).day;
    int nowDay = new DateTime.now().day;

    if (lastDay != nowDay) return LoginStatus.SyncUpdate;

    return LoginStatus.OffLine;
  }

  void loginByOnline(BuildContext context, SyncType syncType, LoginInputInfo loginInputInfo) {
    LoadingDialog.show(context, msg: 'Login...');
    try {
      LoginRequestBean loginRequestBean = new LoginRequestBean();
      loginRequestBean
        ..userName = loginInputInfo.userCode
        ..password = loginInputInfo.password
        ..versionNum = DeviceInfo().versionName
        ..isChangePwd = false
        ..newPassword = ""
        ..platForm = "Android";

      Application.logger.i('request = ${loginRequestBean.toJson()}');

      LoginResponseStatus responseStatus;
      Observable.fromFuture(ApiService.getDataByLogin(loginRequestBean)).listen((response) {
        LoadingDialog.dismiss(context);
        Application.logger.i('''
        url = ${response.request.baseUrl + response.request.path}
        response = ${response.data}''');
        LoginResponseBean responseBean = LoginResponseBean.fromJson(response.data);
        if (responseBean.status == 1) {


          DateTime serviceTime = DateUtil.getDateTime(responseBean.result.serverTime);
          DateTime localTime = DateTime.now();
          Duration diff = localTime.difference(serviceTime);
//          if (diff.inMinutes.abs() > 15) {
//            responseStatus = LoginResponseStatus.LocalServeTimeDifference;
//            CustomerDialog.show(context,
//                msg: 'Your phone time is incorrect.\n'
//                    'Phone time ${DateUtil.getDateStrByDateTime(new DateTime.now())}\n'
//                    'Server time ${responseBean.result.serverTime}',
//                onConfirm: (){
//                  if(Platform.isAndroid){
//                    AndroidIntent intent = const AndroidIntent(
//                      action: 'android.settings.DATE_SETTINGS',
//                    );
//                    intent.launch();
//                  }
//                });
//            return;
//          }
          loginSuccess(context, syncType, responseBean, loginInputInfo);


        } else {


          AppLogManager.insert(ExceptionType.WARN.toString(), msg: response.toString());
          responseStatus = LoginResponseStatus.OnLineError;
          int exceptionCode = responseBean.exceptionCode;

          if (exceptionCode == 1) {
            responseStatus = LoginResponseStatus.ErrorUserMsg;
            CustomerDialog.show(context, msg: 'Your account or password is incorrect. Please check it and try again.');
            return;
          }

          if (exceptionCode == 2) {
            responseStatus = LoginResponseStatus.ErrorPasswordExpired;
            CustomerDialog.show(context, msg: 'Incorrect username or password expired!');
            return;
          }

          if (exceptionCode == 3) {
            responseStatus = LoginResponseStatus.AccountLock;
            CustomerDialog.show(context, msg: 'The account had been locked. Please contact your manager.');
            return;
          }

          if (exceptionCode == 4) {
            responseStatus = LoginResponseStatus.AccountInvalid;
            CustomerDialog.show(context, msg: 'The account is invalid. Please contact your manager.');
            return;
          }

          if (exceptionCode == 7) {
            responseStatus = LoginResponseStatus.NoShipment;
            CustomerDialog.show(context, msg: 'You had not been assigned shipments, please contact your manager.');
            return;
          }

          if (exceptionCode == 9) {
            responseStatus = LoginResponseStatus.ImeiNotMatch;
            CustomerDialog.show(context, msg: 'The IMEI is incorrect. Please contact your manager.');
            return;
          }

          CustomerDialog.show(context, msg: 'Login failed. Please check your network and try again.');


        }
      }, onError: (e) {
        LoadingDialog.dismiss(context);
        Application.logger.e(e.toString());
        CustomerDialog.show(context, msg: 'Login failed. Please check your network and try again.');
      });
    } catch (e) {}
  }

  Future loginSuccess(BuildContext context, SyncType syncType, LoginResponseBean responseBean, LoginInputInfo inputInfo) async {
    await saveUserToDb(responseBean, syncType, inputInfo);

    syncData(context, syncType);
  }

  void syncData(BuildContext context, SyncType syncType) {
    SyncManager.start(syncType, context: context, onSuccessSync: () {
      onClickCheckout(context);
    }, onFailSync: (e) async {
      await clearUserToDb();
      appConfigEntity.syncInitFlag = null;
      CustomerDialog.show(context, msg: 'Sync fail');
    });
  }

  Future clearUserToDb() async {
    await AppConfigManager.deleteAll();
  }

  Future saveUserToDb(LoginResponseBean responseBean, SyncType syncType, LoginInputInfo inputInfo) async {
    List<AppConfigEntity> list = await AppConfigManager.queryAll();
    SettingInfo settingInfo = await SettingPresenter.getCurSettingInfo();
    AppConfigEntity entity;
    if (ObjectUtil.isEmptyList(list)) {
      entity = AppConfigEntity.Empty();
      entity
        ..userCode = responseBean.loginName
        ..userName = responseBean.result.userName
        ..password = inputInfo.password
        ..syncInitFlag = syncType.toString()
        ..version = DeviceInfo().versionName
        ..lastUpdateTime = DateUtil.getNowDateStr()
        ..host = settingInfo.host
        ..port = settingInfo.port
        ..isSsl = SettingInfo.boolToStr(settingInfo.isSsl)
        ..env = settingInfo.env;
      await AppConfigManager.insert(entity);
    } else {
      AppConfigEntity entity = list[0];
      entity
        ..userCode = responseBean.loginName
        ..userName = responseBean.result.userName
        ..password = inputInfo.password
        ..syncInitFlag = syncType.toString()
        ..version = DeviceInfo().versionName
        ..lastUpdateTime = DateUtil.getNowDateStr();
      await AppConfigManager.update(entity);
    }
    await fillAppConfigEntity();
  }

}
