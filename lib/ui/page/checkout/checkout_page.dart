import 'package:mib/res/colors.dart';
import 'package:mib/res/strings.dart';
import 'package:mib/res/styles.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'checkout_presenter.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/30 11:43

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(IntlUtil.getString(context, Ids.checkout_title)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                CheckoutPresenter presenter = Provider.of<CheckoutPresenter>(context);
                presenter.onClickRight(context);
              },
            )
          ],
        ),
        body: Consumer<CheckoutPresenter>(builder: (context, presenter, _) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              presenter.onClickItem(context, presenter.shipmentNo);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              color: ColorsRes.gray_normal,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'INVENTORY CHECKOUT',
                            style: TextStyles.large,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10),),
                          Text(
                            'Shipment No:${presenter.shipmentNo}',
                            style: TextStyles.small,
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        presenter.getIsCompleteText(),
                        style: TextStyles.large,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }));
  }
}
