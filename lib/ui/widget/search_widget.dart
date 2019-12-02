import 'package:mib/application.dart';
import 'package:mib/res/strings.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/dialog/customer_dialog.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/23 14:16

class SearchEvent {}

class SearchWidget extends StatefulWidget {
  final Function(String str) onSearch;

  SearchWidget(this.onSearch, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchState(onSearch);
  }

}

class _SearchState extends State<SearchWidget> {
  final Function(String str) onSearch;
  final TextEditingController textCtrl = new TextEditingController();
  final BehaviorSubject subject = BehaviorSubject<String>();

  _SearchState(this.onSearch);


  @override
  void initState() {
    super.initState();

    eventBus.on<SearchEvent>().listen((event){
      textCtrl.text = '';
    });

    textCtrl.addListener(() {
      subject.add(textCtrl.text);
    });

    subject.debounceTime(Duration(milliseconds: 200)).listen((str) {
      onSearch(str);
    });

  }

  @override
  void dispose() {
    super.dispose();
    subject.close();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        height: 36,
        child: Theme(
          data: ThemeData(primaryColor: Colors.grey),
          child: TextField(
            style: TextStyles.normal,
            controller: textCtrl,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 0, bottom: 0),
              hintText: IntlUtil.getString(context, Ids.userName),
              prefixIcon: GestureDetector(
                onTap: () {
                  CustomerDialog.show(context, msg: 'hahaha');
                },
                child: Icon(Icons.search),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  CustomerDialog.show(context, msg: 'hahaha');
                },
                child: Icon(Icons.highlight_off),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

