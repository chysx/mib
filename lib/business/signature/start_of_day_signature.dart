import 'package:mib/business/signature/signature_logic.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 17:42

class StartOfDaySignature extends SignatureLogic {
  StartOfDaySignature({String accountNumber, OnSuccess onSuccess, OnFail onFail})
      :super(
      accountNumber: accountNumber, onSuccess: onSuccess, onFail: onFail);

  @override
  Future<String> getDriverSignOffConfig() {
    // TODO: implement getDriverSignOffConfig
    return null;
  }

  @override
  int getFunctionType() {
    // TODO: implement getFunctionType
    return null;
  }

  @override
  String getRoleType() {
    // TODO: implement getRoleType
    return null;
  }

  @override
  bool isAuthorization() {
    // TODO: implement isAuthorization
    return null;
  }

  @override
  Future<bool> isNeedRoleSignOff() {
    // TODO: implement isNeedRoleSignOff
    return Future.value(false);
  }
}