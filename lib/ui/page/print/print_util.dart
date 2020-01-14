import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/ui/dialog/list_dialog.dart';
import 'package:mib/ui/dialog/loading_dialog.dart';
import 'package:mib/ui/dialog/model/key_value_info.dart';
import 'package:mib/utils/file_util.dart';

import 'blue_manager.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-14 14:16

class PrintUtil {
  static void showBlueDialog(BuildContext context){
    LoadingDialog.show(context,msg: 'loading...');
    BlueManager().scan((deviceList){
      LoadingDialog.dismiss(context);
      List<KeyValueInfo> list = deviceList.map((device){
        return new KeyValueInfo()
          ..name = device.name
          ..value = device.name
          ..data = device;
      }).toList();

      //添加弹出框消失回调方法
      ListDialog.show(context,title: 'title',data: list,onSelect: (reason) async {
        BluetoothDevice device = reason.data;
        if(Platform.isAndroid){
          BlueManager().sendAddress(device.id.toString());
        }else if(Platform.isIOS){
          BlueManager().sendAddress(device.name);
        }
      });
    });

  }


  static Future<Uint8List> savePrintPng(GlobalKey rootWidgetKey) async {
    try {
      RenderRepaintBoundary boundary =
      rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await FileUtil.saveFileData(pngBytes,Constant.WORK_IMG,'print.png');
      return pngBytes;//这个对象就是图片数据
    } catch (e) {
      print(e);
    }
    return null;
  }

}