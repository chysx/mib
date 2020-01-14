import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/net/api_service.dart';
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

  static PriceRequestBean createRequestTest() {

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

  static PriceRequestBean createRequest(List<BaseProductInfo> productList) {

    PriceRequestBean requestBean = new PriceRequestBean();
    requestBean
      ..token = '95320bca-b78d-4de8-b0b6-4cd07a3727ba'
      ..customerRef = 'CM02143010104'
      ..calcDate = '2019-11-07'
      ..bottlersCode = 'MIB';

    requestBean.products = [];

    for(BaseProductInfo info in productList) {
      Product product = new Product();
      product.productRef = info.code;
      if(info.actualCs != 0){
        product
          ..quantity = info.actualCs
          ..unitOfMeasure = ProductUnit.CS;
      }

      if(info.actualEa != 0){
        product
          ..quantity = info.actualEa
          ..unitOfMeasure = ProductUnit.EA;
      }
      requestBean.products.add(product);
    }

    return requestBean;
  }


  static Future start({OnSuccess onSuccessSync, OnFail onFailSync, BuildContext context,List<BaseProductInfo> productList}) async {
//    HttpService().configDioByUrl('https://mibsfa.ebestmobile.net:9999');
    if (context != null) LoadingDialog.show(context,msg: 'pricing...');
    try{
      Response<Map<String, dynamic>> reponse = await ApiService.getPriceCheck(createRequest(productList));
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