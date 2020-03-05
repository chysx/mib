import 'package:flutter/material.dart';
import 'package:mib/res/dimens.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/start_of_day/start_of_day_presenter.dart';
import 'package:mib/ui/widget/fold_widget.dart';
import 'package:mib/ui/widget/timer_widget.dart';
import 'package:provider/provider.dart';


/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-11 17:31

class StartOfDayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartOfDayState();
  }


}

class _StartOfDayState extends State<StartOfDayPage>{

  TextEditingController controller = new TextEditingController();

  void ctrlOdometer(StartOfDayPresenter presenter) {
    if (controller == null) {
      controller = new TextEditingController();
      controller.addListener(() {
        presenter.odometer = controller.text;
      });
    }

    controller.text = presenter.odometer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('START OF DAY'),
      ),
      body: Consumer<StartOfDayPresenter>(
        builder: (context, presenter, _){
          ctrlOdometer(presenter);
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FoldWidget(
                        msg: 'VEHICLE CHECK',
                        child: Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Column(
                            children: presenter.widgetList,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      FoldWidget(
                        msg: 'ADDITION INFO',
                        child: Container(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text('Start Time:',style: TextStyles.normal,),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TimerWidget(),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text('Planned Shipments:',style: TextStyles.normal,),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(presenter.shipmentCount.toString(),style: TextStyles.normal,),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text('Planned Customers:',style: TextStyles.normal,),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(presenter.customerCount.toString(),style: TextStyles.normal,),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text('Odometer:',style: TextStyles.normal,),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 36,
                                      child: Theme(
                                        data: ThemeData(primaryColor: Colors.grey),
                                        child: TextField(
                                          controller: new TextEditingController(),
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyles.normal,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 2),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(0),
                                              ),
                                              hintText: 'Enter odometer'
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(''),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text('Driver Sign:',style: TextStyles.normal,),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: RaisedButton(
                                        onPressed: () {
                                          presenter.onClickSign(context);
                                        },
                                        child: Text(
                                          'SIGN',
                                          style: TextStyle(color: Colors.black, fontSize: Dimens.font_large),
                                        ),
                                        color: Colors.white,
                                      )
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(''),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              RaisedButton(
                onPressed: () {
                  presenter.onClickStart(context);
                },
                child: Text(
                  'START OF DAY',
                  style: TextStyle(color: Colors.white, fontSize: Dimens.font_large),
                ),
                color: Colors.red,
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
            ],
          );
        },
      ),
    );
  }

}