import 'dart:typed_data';

import 'package:mib/common/constant.dart';
import 'package:mib/res/colors.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/utils/file_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/27 11:10

class SignatureDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var signature = Signature(
      width: 300,
      height: 300,
      backgroundColor: Colors.white,
    );
    return AlertDialog(
      backgroundColor: ColorsRes.gray_normal,
      contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      title: Text('Signature'),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 10,top: 15,right: 10,bottom: 15),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 60,
                            child: Text(
                              'Name:',
                              style: TextStyles.normal,
                            ),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: ColorsRes.gray_normal),
                            child: SizedBox(
                              width: 200,
                              child: TextField(
                                style: TextStyles.normal,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width:60,
                            child: Text('Title:', style: TextStyles.normal,),
                          ),
                          Theme(
                            data: ThemeData(primaryColor: ColorsRes.gray_normal),
                            child: SizedBox(
                              width: 200,
                              child: TextField(
                                style: TextStyles.normal,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 1)),
            signature
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('ok'),
          onPressed: () async {
            if (signature.isNotEmpty) {
              Uint8List data = await signature.exportBytes();
              FileUtil.saveFileData(data, Constant.WORK_IMG, 'signature.png');
              dismiss(context);
            } else {
              Fluttertoast.showToast(msg: 'You must signature.');
            }

          },
        ),
        FlatButton(
          child: Text('cancel'),
          onPressed: () {
            dismiss(context);
          },
        )
      ],
    );
  }

  static show(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new SignatureDialog();
        });
  }

  static dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
