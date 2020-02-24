import 'package:mib/common/constant.dart';
import 'package:mib/res/dimens.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/route/page_builder.dart';
import 'package:flutter/material.dart';

import '../../application.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/26 17:38

class DrawerWidget extends StatelessWidget {
  final List<MenuInfo> menuInfoList = [];
  final String page;

  DrawerWidget({this.page, Key key}) : super(key: key) {

    List<MenuInfo> menuTempList = [

      new MenuInfo()
      ..page = ConstantMenu.CHECK_OUT
      ..title = ConstantMenu.CHECK_OUT
      ..imgPath = 'assets/imgs/menu_check_out.png',

      new MenuInfo()
        ..page = ConstantMenu.ROUTE
        ..title = ConstantMenu.ROUTE
        ..imgPath = 'assets/imgs/menu_route.png',

      new MenuInfo()
      ..page = ConstantMenu.CHECK_IN
      ..title = ConstantMenu.CHECK_IN
      ..imgPath = 'assets/imgs/menu_check_in.png',

      new MenuInfo()
        ..page = ConstantMenu.DARSHBOARD
        ..title = ConstantMenu.DARSHBOARD
        ..imgPath = 'assets/imgs/menu_daily_summary.png',

      new MenuInfo()
      ..page = ConstantMenu.SYNC
      ..title = ConstantMenu.SYNC
      ..imgPath = 'assets/imgs/menu_sync.png',

      new MenuInfo()
      ..page = ConstantMenu.SETTING
      ..title = ConstantMenu.SETTING
      ..imgPath = 'assets/imgs/menu_setting.png',

      new MenuInfo()
      ..page = ConstantMenu.LOGOUT
      ..title = ConstantMenu.LOGOUT
      ..imgPath = 'assets/imgs/menu_log_out.png'

    ];

    menuInfoList.addAll(menuTempList);

    _setCurMenuInfo();
  }

  _setCurMenuInfo() {
    for (MenuInfo menuInfo in menuInfoList) {
      if (menuInfo.page == page) {
        menuInfo.isSelect = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);
  }

  void _onTap(BuildContext context, String goPage) {
    print('page = $goPage');
    if (page != goPage) {
      if (goPage == ConstantMenu.CHECK_OUT) {
        Navigator.pushReplacementNamed(context, PageName.check_out_shipment.toString(),arguments: <String,dynamic>{});
      }
      if (goPage == ConstantMenu.CHECK_IN) {
        Navigator.pushReplacementNamed(context, PageName.check_in_shipment.toString(),arguments: <String,dynamic>{});

      }
      if (goPage == ConstantMenu.ROUTE) {
        Navigator.pushReplacementNamed(context, PageName.route.toString(),arguments: <String,dynamic>{});

      }
      if (goPage == ConstantMenu.DARSHBOARD) {
        Navigator.pushReplacementNamed(context, PageName.daily.toString(),arguments: <String,dynamic>{});

      }
      if (goPage == ConstantMenu.SYNC) {
        Navigator.pushReplacementNamed(context, PageName.sync.toString(),arguments: <String,dynamic>{});

      }
      if (goPage == ConstantMenu.SETTING) {
        Navigator.pushReplacementNamed(context, PageName.settings.toString(),arguments: <String,dynamic>{});

      }
      if (goPage == ConstantMenu.LOGOUT) {
        Navigator.popUntil(context, ModalRoute.withName(PageName.root.toString()));
      }
    }
  }

  Widget _buildHeader() {
    return DrawerHeader(
        padding: EdgeInsets.zero,
        child: Container(
          color: Colors.blue,
          child: Stack(
            alignment: FractionalOffset.centerLeft,
            children: <Widget>[
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Image.asset('assets/imgs/login_logo_480.png'),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                    ),
                    Expanded(
                      child: Text(
                        Application.user.userName,
                        style: TextStyles.normal,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildContent(BuildContext context) {
    return menuInfoList.map((menu) {
      return Container(
        color: menu.isSelect ? Colors.blue : Colors.grey,
        child: ListTile(
          leading: Image.asset(menu.imgPath),
          title: Text(
            menu.title,
            style: TextStyle(color: Colors.white, fontSize: Dimens.font_normal),
          ),
          onTap: () {
            _onTap(context, menu.page);
          },
        ),
      );
    }).toList();
  }

  Widget _buildDrawer(BuildContext context) {
    List<Widget> list = [];
    list.add(_buildHeader());
    list.addAll(_buildContent(context));
    return Drawer(
      child: Container(
        color: Colors.grey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: list,
        ),
      ),
    );
  }
}

class MenuInfo {
  bool isSelect = false;
  String imgPath;
  String title;
  String page;
}
