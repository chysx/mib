import 'package:flutter/material.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/dialog/model/key_value_info.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-20 16:52

class DropDownWidget<T> extends StatefulWidget {
  final List<KeyValueInfo> reasonList;
  final Function(KeyValueInfo<T> info) onSelect;
  DropDownWidget({this.reasonList, this.onSelect,Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropDownState();
  }

}

class _DropDownState extends State<DropDownWidget> {
  KeyValueInfo selectValue;
  List<DropdownMenuItem<KeyValueInfo>> makeDropList() {
    return widget.reasonList.map((item) {
      return DropdownMenuItem<KeyValueInfo>(
        value: item,
        child: Text(
          item.name,
          style: TextStyles.normal,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.only(left: 10, right: 10,top: 0,bottom: 0),
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: DropdownButton<KeyValueInfo>(
                  isExpanded: true,
                  underline: Container(),
                  value: selectValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectValue = newValue;
                    });
                    if(widget.onSelect != null) widget.onSelect(newValue);
                  },
                  items: makeDropList()),
            ),
          ],
        ),
      );
  }

}