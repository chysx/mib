import 'package:flustars/flustars.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/vansales_summary/vansales_summary_presenter.dart';
import 'package:mib/ui/widget/fold_widget.dart';
import 'package:mib/ui/widget/list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-13 20:48

class VanSalesSummaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VanSalesSummarySate();
  }
}

class _VanSalesSummarySate extends State<VanSalesSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('VansalesSummary'),
          actions: <Widget>[
            Builder(builder: (context) {
              VanSalesSummaryPresenter presenter =
              Provider.of<VanSalesSummaryPresenter>(context);
              Widget icon = IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  presenter.onClickRight(context);
                },
              );
              return presenter.isHideNextButton() ? Container() : icon;
            }),
          ],
        ),
        body: Consumer<VanSalesSummaryPresenter>(
            builder: (context, presenter, _) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FoldWidget(
                      msg: 'VAN SALES INFO',
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  'Delivery No:',
                                  style: TextStyles.normal,
                                ),
                                Spacer(),
                                Text(
                                  presenter.deliveryNo,
                                  style: TextStyles.normal,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Delivery Date:',
                                  style: TextStyles.normal,
                                ),
                                Spacer(),
                                Text(
                                  DateUtil.getDateStrByDateTime(DateTime.now(), format: DateFormat.NORMAL),
                                  style: TextStyles.normal,
                                ),
                              ],
                            ),
//                      Padding(padding: EdgeInsets.only(top: 10),),
//                      Row(
//                        children: <Widget>[
//                          Text('Delivery Note:',style: TextStyles.normal,),
//                          Spacer(),
//                          Text(DeliveryModel().mDeliveryHeader?.DeliveryNote ?? '',style: TextStyles.normal,),
//                        ],
//                      )
                          ],
                        ),
                      ),
                    ),
                    FoldWidget(
                      msg: 'VAN SALES DETAIL',
                      isMore: true,
                      child: Column(
                        children: <Widget>[
                          ListHeaderWidget(
                            names: ['Product', 'Base', 'Qty', 'Discount', 'Net'],
                            supNames: ['', 'AED', 'CS/EA', 'AED', 'AED'],
                            weights: [1, 1, 1, 1, 1],
                            aligns: [
                              TextAlign.center,
                              TextAlign.center,
                              TextAlign.center,
                              TextAlign.center,
                              TextAlign.center,
                            ],
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: presenter.productList.length,
                            itemBuilder: (context, index) {
                              BaseProductInfo info = presenter.productList[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${info.code} ${info.name ?? ''}',
                                        textAlign: TextAlign.left,
                                        style: TextStyles.small,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        info.basePrice?.toString() ?? '0.00',
                                        textAlign: TextAlign.center,
                                        style: TextStyles.small,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        info.getActualShowStrByType(
                                            TaskType.Delivery),
                                        textAlign: TextAlign.center,
                                        style: TextStyles.small,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        info.discount?.toString() ?? '0.00',
                                        textAlign: TextAlign.center,
                                        style: TextStyles.small,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        info.netPrice?.toString() ?? '0.00',
                                        textAlign: TextAlign.center,
                                        style: TextStyles.small,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 2,
                              );
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Total: ${BaseProductInfo.getTotalActualCs(presenter.productList)}CS ${BaseProductInfo.getTotalActualEa(presenter.productList)}EA',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Base Price:',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    presenter.deliveryHeader.BasePrice ?? '0',
                                    style: TextStyles.normal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Discount:',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    presenter.deliveryHeader.Discount ?? '0',
                                    style: TextStyles.normal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Net Price:',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    presenter.deliveryHeader.NetPrice ?? '0',
                                    style: TextStyles.normal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Tax:',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    presenter.deliveryHeader.Tax ?? '0',
                                    style: TextStyles.normal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Deposit:',
                                    style: TextStyles.normal,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    presenter.deliveryHeader.Deposit ?? '0',
                                    style: TextStyles.normal,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
//                      Container(
//                        padding:
//                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                        child: Row(
//                          children: <Widget>[
//                            Expanded(
//                              flex: 2,
//                              child: Text(
//                                '',
//                                style: TextStyles.normal,
//                              ),
//                            ),
//                            Expanded(
//                              flex: 1,
//                              child: Text(
//                                'Total Price:',
//                                style: TextStyles.normal,
//                              ),
//                            ),
//                            Expanded(
//                              flex: 1,
//                              child: Text(
//                                '${presenter.get2Decimal()}',
//                                style: TextStyles.normal,
//                                textAlign: TextAlign.right,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
                          Offstage(
                            offstage: presenter.isReadOnly,
                            child: Container(
//                        padding: EdgeInsets.only(
//                            left: 10, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                      onPressed: () {
                                        presenter.priceCalculate(context);
                                      },
                                      child: Text('Calute'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FoldWidget(
                      msg: 'EMPTY RETURN',
                      isMore: true,
                      child: Column(
                        children: <Widget>[
                          ListHeaderWidget(
                            names: ['Product', 'Qty'],
                            supNames: ['', ''],
                            weights: [1, 1],
                            aligns: [
                              TextAlign.center,
                              TextAlign.center,
                            ],
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: presenter.emptyProductList.length,
                            itemBuilder: (context, index) {
                              BaseProductInfo info =
                              presenter.emptyProductList[index];
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${info.code} ${info.name ?? ''}',
                                        textAlign: TextAlign.left,
                                        style: TextStyles.small,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        info.getActualShowStrByType(
                                            TaskType.EmptyReturn),
                                        textAlign: TextAlign.center,
                                        style: TextStyles.small,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 2,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
