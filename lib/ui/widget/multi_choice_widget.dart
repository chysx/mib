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


typedef OnSelectedByMulti = void Function(List<DSD_M_TruckCheckList_Entity> infoList,Map<int,int> hasMap);

class MultiChoiceWidget extends StatefulWidget {
  final DSD_M_TruckCheckList_Entity askEntity;
  final List<DSD_M_TruckCheckList_Entity> truckList;
  final OnSelectedByMulti onSelected;
  final int index;
  final int totalAns;

  MultiChoiceWidget(this.askEntity,this.truckList,this.index,this.totalAns,this.onSelected, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiChoiceState();
  }

}

class _MultiChoiceState extends State<MultiChoiceWidget> {
  Map<int,bool> hashMap = {};

  bool isSelected(DSD_M_TruckCheckList_Entity entity) {
    return hashMap[entity.Id] ?? false;
  }

  List<DSD_M_TruckCheckList_Entity> getSelectedTruckList() {
    List<DSD_M_TruckCheckList_Entity> result = [];
    for(DSD_M_TruckCheckList_Entity entity in widget.truckList){
      if(isSelected(entity)){
        result.add(entity);
      }
    }
    return result;
  }

  void controlSelected(int id) {
    if(hashMap[id] != null && hashMap[id]){
      hashMap[id] = false;
    }else {
      hashMap[id] = true;
    }
  }

  int getTotalIndex(int id) {
    int totalIndex = 0;
    for(DSD_M_TruckCheckList_Entity info in widget.truckList) {
      totalIndex++;
      if(info.Id == id) break;
    }
    return widget.totalAns + totalIndex;
  }

  Map<int,int> getTotalIndexMap() {
    Map<int,int> resultMap = {};
    for(int id in hashMap.keys) {
      if(hashMap[id]) resultMap[id] = getTotalIndex(id);
    }
    return resultMap;
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
    return widget.truckList.map((item){
      return
        RaisedButton(
          onPressed: () {
            setState(() {
              controlSelected(item.Id);
            });
            widget.onSelected(getSelectedTruckList(),getTotalIndexMap());
          },
          child: Text(
            item.Content,
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
        Padding(
          padding: EdgeInsets.only(top: 10,bottom: 10),
        ),
        Row(
          children: <Widget>[
            getMust(widget.askEntity.MustToDo == MustToDo.TRUE),
            Expanded(child: Text(widget.index.toString() + '.' +widget.askEntity.Content,style: TextStyles.large,)),
          ],
        ),

        Wrap(
          spacing: 20,
          runSpacing: 2,
          children: getWidgetList(),
        ),

      ],
    );
  }


}