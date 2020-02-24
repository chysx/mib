import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mib/res/strings.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/route/customer_info.dart';
import 'package:mib/ui/widget/drop_down_widget.dart';

import 'model/key_value_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-20 16:17


typedef OnConfirm = void Function(KeyValueInfo info);
typedef OnCancel= void Function();
class CheckInCancelDialog extends StatelessWidget {
  final OnConfirm onConfirm;
  final OnCancel onCancel;
  final String title;
  final List<CustomerInfo> customerList;
  final List<KeyValueInfo> reasonList;
  KeyValueInfo selectedValue;

  CheckInCancelDialog({this.title, this.customerList,this.reasonList,this.onConfirm,this.onCancel, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        FlatButton(
          child: Text(IntlUtil.getString(context, Ids.general_confirm)),
          onPressed: () {
            if(selectedValue == null){
              Fluttertoast.showToast(msg: 'Please select reason');
              return;
            }
            dismiss(context);
            if(onConfirm != null) onConfirm(selectedValue);
          },
        ),
        FlatButton(
          child: Text(IntlUtil.getString(context, Ids.general_cancel)),
          onPressed: () {
            dismiss(context);
            if(onCancel != null) onCancel();
          },
        )
      ],
      content: Container(
        width: 380,
        height: 320,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: customerList.length,
                  itemBuilder: (context, index) {
                    CustomerInfo info = customerList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          info.accountNumber,
                          style: TextStyles.normal,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Text(
                          info.name,
                          style: TextStyles.normal,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),

            DropDownWidget(
              reasonList: reasonList,
              onSelect: (info){
                selectedValue = info;
              },
            ),

          ],
        ),
      ),
    );
  }

  static show<T>(BuildContext context, {String title,List<CustomerInfo> customerList,List<KeyValueInfo> reasonList,OnConfirm onConfirm,OnCancel onCancel}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return new CheckInCancelDialog(title: title,customerList: customerList,reasonList: reasonList,onConfirm: onConfirm,onCancel: onCancel,);
        });
  }

  static dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
