import 'package:flutter/material.dart';
import 'package:mib/common/business_const.dart';
import 'package:mib/db/table/entity/dsd_m_truckchecklist_entity.dart';
import 'package:mib/res/dimens.dart';
import 'package:mib/res/styles.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 17:50

typedef OnSelectedByBool = void Function(String info,int totalIndex);


class BoolChoiceWidget extends StatefulWidget {
  final DSD_M_TruckCheckList_Entity askEntity;
  final OnSelectedByBool onSelected;
  final int index;
  final int totalAns;

  BoolChoiceWidget(this.askEntity,this.index,this.totalAns,this.onSelected, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BoolChoiceState();
  }

}

class _BoolChoiceState extends State<BoolChoiceWidget> {

  String selectId;

  bool isSelected(String id) {
    return id == selectId;
  }

  int getTotalIndex(String id) {
    return id == 'Yes' ? widget.totalAns + 1 : widget.totalAns + 2;
  }

  Widget getMust(bool isMust) {
    return isMust
        ? Text(
      '*',
      style: TextStyle(color: Colors.red),
    )
        : Container();
  }

  List<Widget> getWidgetList() {
    List<String> list = ['Yes','No'];
    return list.map((item){
      return
        RaisedButton(
          onPressed: () {
            setState(() {
              selectId = item;
            });
            widget.onSelected(item,getTotalIndex(item));
          },
          child: Text(
            item,
            style: TextStyle(color: isSelected(item) ? Colors.white : Colors.black , fontSize: Dimens.font_normal),
          ),
          color: isSelected(item) ? Colors.red : Colors.white,
        );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            getMust(widget.askEntity.MustToDo == MustToDo.TRUE),
            Text(widget.index.toString() + '.' +widget.askEntity.Content,style: TextStyles.large,),
          ],
        ),

        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: getWidgetList(),
        ),

      ],
    );
  }

}