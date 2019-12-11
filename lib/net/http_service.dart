import 'package:dio/dio.dart';
import 'package:mib/net/http_config.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/7/30 17:12

class HttpService {
  static HttpService _instance;
  Dio dio;

  HttpService._();

  static HttpService _getInstance() {
    if (_instance == null) {
      _instance = new HttpService._();
      _instance.dio = new Dio(configDio());
    }
    return _instance;
  }

  static BaseOptions configDio() {
    return new BaseOptions(baseUrl: new HttpConfig().api(), connectTimeout: TimeOut.CONNECT_TIMEOUT,
        receiveTimeout: TimeOut.READ_TIMEOUT);
  }

  factory HttpService() => _getInstance();

  void resetConfigDio(){
    dio.options = configDio();
  }


  configDioByUrl(String url) {
    dio.options =  new BaseOptions(baseUrl: url, connectTimeout: TimeOut.CONNECT_TIMEOUT,
        receiveTimeout: TimeOut.READ_TIMEOUT);
  }
}
