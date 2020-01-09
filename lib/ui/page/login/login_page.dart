
import 'package:mib/common/constant.dart';
import 'package:mib/res/colors.dart';
import 'package:mib/res/strings.dart';
import 'package:mib/ui/page/login/login_presenter.dart';
import 'package:mib/ui/widget/drawer_widget.dart';
import 'package:mib/utils/device_info.dart';
import 'package:fluintl/fluintl.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/1 15:45

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<LoginPage> with WidgetsBindingObserver{
  TextEditingController userCtrl;
  TextEditingController pwdCtrl;
  FocusNode userFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();

  void ctrlUserName(LoginPresenter presenter) {
    if (userCtrl == null) {
      userCtrl = new TextEditingController();
      userCtrl.addListener(() {
        presenter.inputInfo.userCode = userCtrl.text;
      });
    }

    userCtrl.text = presenter.inputInfo.userCode;
  }

  void ctrlPassword(LoginPresenter presenter) {
    if (pwdCtrl == null) {
      pwdCtrl = TextEditingController();
      pwdCtrl.addListener(() {
        presenter.inputInfo.password = pwdCtrl.text;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);//添加观察者
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);//销毁
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){

    }
  }

  void hideFocus() {
    userFocus.unfocus();
    pwdFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFDF2E4),
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Image.asset(
                    'assets/imgs/login_logo_960.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Consumer<LoginPresenter>(
                builder: (context, presenter, _) {
                  ctrlUserName(presenter);
                  ctrlPassword(presenter);
                  return Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                                labelText: IntlUtil.getString(context, Ids.userName),
                                hintText: IntlUtil.getString(context, Ids.userName),
                                prefixIcon: Icon(Icons.person)),
                            controller: userCtrl,
                            focusNode: userFocus,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            controller: pwdCtrl,
                            obscureText: true,
                            focusNode: pwdFocus,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    color: ColorsRes.brown_normal,
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      hideFocus();
                                      presenter.login(context, presenter.inputInfo);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    hideFocus();
                                    presenter.onClickSetting(context);
                                  },
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.settings,
                                          color: ColorsRes.brown_normal,
                                        ),
                                        Text(
                                          "Setting",
                                          style: TextStyle(color: ColorsRes.brown_normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Version:${DeviceInfo().versionName}",
                                      style: TextStyle(color: ColorsRes.brown_normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

}
