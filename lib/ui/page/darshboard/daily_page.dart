import 'package:flutter/material.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/res/colors.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/widget/drawer_widget.dart';
import 'package:provider/provider.dart';

import 'daily_presenter.dart';


/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 15:57

class DailyPage extends StatelessWidget {

  List<DropdownMenuItem<String>> makeDropList(DailyPresenter presenter) {
    return presenter.shipmentList.map((item) {
      return DropdownMenuItem<String>(
        value: item.no,
        child: Text(
          item.no,
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
        title: Text('DAILYSUMMARY'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.local_shipping),
            onPressed: () {
              DailyPresenter presenter = Provider.of<DailyPresenter>(context);
              presenter.onClickRight(context);
            },
          )
        ],
      ),
      backgroundColor: ColorsRes.gray_small,
      body: Consumer<DailyPresenter>(
          builder: (context,presenter,_){
          return Container(
            padding: EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),

            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'SHIPMENT NO:   ',
                      style: TextStyles.normal,
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10,top: 0,bottom: 0),
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                      ),
                      child: Row(
                        children: <Widget>[
                          DropdownButton<String>(
                              underline: Container(),
                              value: presenter.currentShipment?.no,
                              onChanged: (newValue) {
                                presenter.onEvent(DailyEvent.SelectShipment, newValue);
                              },
                              items: makeDropList(presenter)),
                        ],
                      ),
                    )

                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              color: ColorsRes.gray_normal,
                              child: Text(
            'CALL RATE',
            style: TextStyles.normal,
            ),
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 4,top: 4),
                                child: Text(
                                  'Visited:${presenter.map[presenter.currentShipment?.no]?.visitedCount}',
                                  style: TextStyles.small,
                                )
                            ),


                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            Center(child:
            Text(
            '${presenter.map[presenter.currentShipment?.no]?.getShowStr()}%',
            style: TextStyle(fontSize: 24,color: Colors.red),
            ),),

                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Center(child: Text(
                              'Rate',
                              style: TextStyles.normal,
                            ),),

                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            Container(
                              alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 4,bottom: 4),
                                child: Text(
                                  'Plan Visited:${presenter.map[presenter.currentShipment?.no]?.totalCount}',
                                  style: TextStyles.small,
                                )
                            ),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              color: ColorsRes.gray_normal,
                              child: Text(
                                'DAILY ACHIEVED',
                                style: TextStyles.normal,
                              ),
                            ),

                            Container(
                                padding: EdgeInsets.only(left: 4,top: 4),
                                child: Text(
                                  'Delivered:${presenter.map[presenter.currentShipment?.no]?.visitedCount}',
                                  style: TextStyles.small,
                                )
                            ),


                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            Center(child:
                            Text(
                              '${presenter.map[presenter.currentShipment?.no]?.getShowStr()}%',
                              style: TextStyle(fontSize: 24,color: Colors.red),
                            ),),

                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Center(child: Text(
                              'Called',
                              style: TextStyles.normal,
                            ),),

                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),

                            Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 4,bottom: 4),
                                child: Text(
                                  'Plan Delivery:${presenter.map[presenter.currentShipment?.no]?.totalCount}',
                                  style: TextStyles.small,
                                )
                            ),

                          ],
                        ),
                      ),

                    ),

                  ],
                ),
              ],
            ),
          );
      }
      ),
      drawer: DrawerWidget(page: ConstantMenu.DARSHBOARD,),
    );
  }

}