import 'package:mib/business/signature/signature_logic.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/common/system_config.dart';
import 'package:mib/db/manager/system_config_manager.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-11 18:15

class DeliverySignature extends SignatureLogic{
  DeliverySignature({String accountNumber,OnSuccess onSuccess,OnFail onFail})
  :super(accountNumber: accountNumber,onSuccess: onSuccess, onFail: onFail) ;

  @override
  Future<String> getDriverSignOffConfig() async {
    return await SystemManager.getSystemConfigValue(Delivery.CATEGORY, Delivery.DRIVER_SIGN_OFF);
  }

  @override
  int getFunctionType() {
    return BizModel.DELIVERY;
  }

  @override
  String getRoleType() {
    return UserType.CUSTOMER;
  }

  @override
  bool isAuthorization() {
    return false;
  }

  @override
  Future<bool> isNeedRoleSignOff() async {
    return await SystemManager.getValueByBoolean(Delivery.CATEGORY, Delivery.CUSTOMER_SIGN_OFF);
  }

}