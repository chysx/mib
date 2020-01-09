import 'package:mib/db/util.dart';
import 'package:mib/res/colors.dart';
import 'package:mib/res/dimens.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/settings/settings_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/2 15:21

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<SettingsPage> {
  TextEditingController hostCtrl;
  TextEditingController portCtrl;

  void ctrlHost(SettingPresenter presenter) {
    if (hostCtrl == null) {
      hostCtrl = new TextEditingController();
      hostCtrl.addListener(() {
        presenter.curSettingInfo.host = hostCtrl.text;
      });
    }
    hostCtrl.text = presenter.curSettingInfo.host;
  }

  void ctrlPort(SettingPresenter presenter) {
    if (portCtrl == null) {
      portCtrl = TextEditingController();
      portCtrl.addListener(() {
        presenter.curSettingInfo.port = portCtrl.text;
      });
    }
    portCtrl.text = presenter.curSettingInfo.port;
  }

  List<DropdownMenuItem<String>> makeDropList(SettingPresenter presenter) {
    return presenter.settingList.map((item) {
      return DropdownMenuItem(
        value: item.env,
        child: Text(
          item.env,
          style: TextStyles.normal,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          child: Text('Setting'),
          onLongPress: () {
            DbUtil.copyDb();
          },
        ),
      ),
      body: Consumer<SettingPresenter>(
        builder: (context, presenter, _) {
          ctrlHost(presenter);
          ctrlPort(presenter);
          return Padding(
            padding: EdgeInsets.all(Dimens.space_normal),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          'SSL:',
                          style: TextStyles.normal,
                        ),
                      ),
                      Checkbox(
                        value: presenter.curSettingInfo.isSsl,
                        onChanged: (value) {
                          presenter.onEvent(SettingEvent.ChangeCheckBox, value);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Server:',
                          style: TextStyles.normal,
                        ),
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                            value: presenter.curSettingInfo.env,
                            isExpanded: true,
                            onChanged: (newValue) {
                              presenter.onEvent(SettingEvent.SelectEnv, newValue);
                            },
                            items: makeDropList(presenter)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Address:',
                          style: TextStyles.normal,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          readOnly: presenter.isDisable(),
                          controller: hostCtrl,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Port:',
                          style: TextStyles.normal,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          readOnly: presenter.isDisable(),
                          controller: portCtrl,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: ColorsRes.brown_normal,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            presenter.onClickSave(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
