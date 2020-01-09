import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mib/net/api_service.dart';
import 'package:mib/net/http_service.dart';
import 'package:mib/price/price_request_bean.dart';
import 'package:mib/price/price_response_bean.dart' as response;
import 'package:mib/ui/dialog/loading_dialog.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-10 15:33


typedef OnFail = void Function(dynamic e);
typedef OnSuccess = void Function(response.PriceResponseBean result);

class PriceManager {

  static PriceRequestBean createRequest() {

    PriceRequestBean requestBean = new PriceRequestBean();
    requestBean
      ..token = '95320bca-b78d-4de8-b0b6-4cd07a3727ba'
      ..customerRef = 'CM02143010104'
      ..calcDate = '2019-11-07'
      ..bottlersCode = 'MIB';

    Product product = new Product();
    product
      ..productRef = '1101'
      ..quantity = 1
      ..unitOfMeasure = '';

    requestBean.products = [product];

    return requestBean;
  }

  static PriceRequestBean createRequestBy() {

    PriceRequestBean requestBean = new PriceRequestBean();
    requestBean
      ..token = '95320bca-b78d-4de8-b0b6-4cd07a3727ba'
      ..customerRef = 'CM02143010104'
      ..calcDate = '2019-11-07'
      ..bottlersCode = 'MIB';

    Product product = new Product();
    product
      ..productRef = '1101'
      ..quantity = 1
      ..unitOfMeasure = '';

    requestBean.products = [product];

    return requestBean;
  }


  static Future start({OnSuccess onSuccessSync, OnFail onFailSync, BuildContext context}) async {
//    HttpService().configDioByUrl('https://mibsfa.ebestmobile.net:9999');
    if (context != null) LoadingDialog.show(context,msg: 'pricing...');
    try{
      Response<Map<String, dynamic>> reponse = await ApiService.getPriceCheck(createRequest());
      response.PriceResponseBean result = response.PriceResponseBean.fromJson(reponse.data);
      print(result.toJson());
      onSuccessSync(result);
    }catch(e) {
      print(e.toString());
      onFailSync(e);
    }finally {
      if (context != null) LoadingDialog.dismiss(context);
    }
  }
}