import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:mib/res/styles.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 12:30

class TimerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerState();
  }

}

class _TimerState extends State<TimerWidget> {
  String time;
  Timer timer;

  @override
  void initState() {
    timeTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(time??'',style: TextStyles.normal,);
  }

  void timeTask() {
    timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        time = DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL);
        print(time);

      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

}