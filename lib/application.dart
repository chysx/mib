import 'package:dio/dio.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/db/table/entity/md_product_entity.dart';
import 'package:mib/log/log4dart.dart';
import 'package:mib/log/log_util.dart';
import 'package:mib/ui/page/login/user.dart';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:logger/logger.dart';
import 'package:mib/utils/file_util.dart';

import 'db/database.dart';
import 'db/table/entity/app_config_entity.dart';
import 'net/http_service.dart';
import 'utils/device_info.dart';
import 'package:event_bus/event_bus.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/2 14:28

EventBus eventBus = new EventBus();

class Application {
  static AppDatabase database;
  static Logger logger;
  static Dio httpService;
  static Router router;
  static DeviceInfo deviceInfo;
  static User user;
  static AppConfigEntity appConfigEntity;
  static Map<String, String> _productMap = {};

  static void install() {
    new DbHelper();
    new DeviceInfo();
    logger = new Log().logger;
    httpService = new HttpService().dio;
    router = new Router();
    DirectoryUtil.getInstance();
    user = new User();
  }

  static void initDataBase() {
    database = new DbHelper().database;
    print('database = $database');
  }

  static Future<Map<String, String>> get productMap async {
    if (_productMap.length > 0) return _productMap;
    List<MD_Product_Entity> list = await database.productDao.findAll();
    for (MD_Product_Entity entity in list) {
      _productMap[entity.ProductCode] = entity.Name;
    }
    return _productMap;
  }

  static configLog4Dart() {
    var config = {
      'appenders': [
        {
          'type': 'CONSOLE',
          'dateFormat' : 'yyyy-MM-dd HH:mm:ss',
          'format': '%d %i %t %l %m',
          'level': 'INFO'
        },
        {
          'type': 'FILE',
          'dateFormat' : 'yyyy-MM-dd HH:mm:ss',
          'format': '%d %i %t %l %m',
          'level': 'INFO',
          'filePattern': 'log',
          'fileExtension': 'txt',
          'path': '${FileUtil.getFilePath(Constant.WORK_LOG)}',
          'rotationCycle': 'DAY'
        },
      ]
    };

    LoggerSuper().init(config);
  }

}
