import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:mib/common/constant.dart';
import 'package:mib/res/colors.dart';
import 'package:mib/res/dimens.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/sync/sync_info.dart';
import 'package:mib/ui/page/sync/sync_presenter.dart';
import 'package:mib/ui/widget/drawer_widget.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/26 17:17

class SyncPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SyncState();
  }
}

class _SyncState extends State<SyncPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  final List<Tab> myTabs = <Tab>[Tab(text: 'CheckOut'), Tab(text: 'Visit'), Tab(text: 'CheckIn')];

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget createCheckOut(SyncPresenter presenter) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 2,
              );
            },
            itemCount: presenter.syncCheckOutList.length,
            itemBuilder: (context, index) {
              SyncInfo info = presenter.syncCheckOutList[index];
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      info.name,
                      style: TextStyles.normal,
                      textAlign: TextAlign.left,
                    )),
                    Expanded(
                        child: Text(
                      info.getStatusMsg(),
                      style: TextStyles.normal,
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: Text(
                      info.time,
                      style: TextStyles.normal,
                      textAlign: TextAlign.right,
                    ))
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
    ;
  }

  Widget createCheckIn(SyncPresenter presenter) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 2,
              );
            },
            itemCount: presenter.syncCheckInList.length,
            itemBuilder: (context, index) {
              SyncInfo info = presenter.syncCheckInList[index];
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      info.name,
                      style: TextStyles.normal,
                    )),
                    Expanded(
                        child: Text(
                      info.getStatusMsg(),
                      style: TextStyles.normal,
                    )),
                    Expanded(
                        child: Text(
                      info.time,
                      style: TextStyles.normal,
                    ))
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
    ;
  }

  Widget createVisit(SyncPresenter presenter) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 2,
              );
            },
            itemCount: presenter.syncVisitList.length,
            itemBuilder: (context, index) {
              SyncInfo info = presenter.syncVisitList[index];
              return Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      info.name,
                      style: TextStyles.normal,
                    )),
                    Expanded(
                        child: Text(
                      info.getStatusMsg(),
                      style: TextStyles.normal,
                    )),
                    Expanded(
                        child: Text(
                      info.time,
                      style: TextStyles.normal,
                    ))
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SYNC'),
        bottom: TabBar(
          controller: tabController,
          tabs: myTabs,
        ),
      ),
      body: Consumer<SyncPresenter>(builder: (context, presenter, _) {
        return Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: <Widget>[
                  createCheckOut(presenter),
                  createVisit(presenter),
                  createCheckIn(presenter),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    presenter.onClickUpdate(context);
                  },
                  child: Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.white, fontSize: Dimens.font_large),
                  ),
                  color: ColorsRes.brown_normal,
                ),
                RaisedButton(
                  onPressed: () {
                    presenter.onClickInit(context);
                  },
                  child: Text(
                    'INIT',
                    style: TextStyle(color: Colors.white, fontSize: Dimens.font_large),
                  ),
                  color: ColorsRes.brown_normal,
                ),
                RaisedButton(
                  onPressed: () {
                    presenter.onClickUpload(context, tabController.index);
                  },
                  child: Text(
                    'UPLOAD',
                    style: TextStyle(color: Colors.white, fontSize: Dimens.font_large),
                  ),
                  color: ColorsRes.brown_normal,
                )
              ],
            )
          ],
        );
      }),
      drawer: DrawerWidget(
        page: ConstantMenu.SYNC,
      ),
    );
  }
}
