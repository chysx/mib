import 'package:mib/common/dictionary.dart';
import 'package:mib/model/base_product_info.dart';
import 'package:mib/model/delivery_model.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/delivery_summary/delivery_summary_presenter.dart';
import 'package:mib/ui/widget/fold_widget.dart';
import 'package:mib/ui/widget/list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/9/17 18:44

class DeliverySummaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeliverySummarySate();
  }

}

class _DeliverySummarySate extends State<DeliverySummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeliverySummary'),
        actions: <Widget>[
          Builder(builder: (context)  {
            DeliverySummaryPresenter presenter = Provider.of<DeliverySummaryPresenter>(context);
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
      body: Consumer<DeliverySummaryPresenter>(builder: (context, presenter, _) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FoldWidget(
                msg: 'DELIVERY INFO',
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Delivery No:',style: TextStyles.normal,),
                          Spacer(),
                          Text(presenter.deliveryNo,style: TextStyles.normal,),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10),),
                      Row(
                        children: <Widget>[
                          Text('Delivery Date:',style: TextStyles.normal,),
                          Spacer(),
                          Text(DeliveryModel().mDeliveryHeader?.PlanDeliveryDate ?? '',style: TextStyles.normal,),
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
                msg: 'DELIVERY DETAIL',
                isMore: true,
                child: Column(
                  children: <Widget>[
                    ListHeaderWidget(
                      names: ['Product','Base', 'Qty','Discount','Net'],
                      supNames: ['','AED', 'CS/EA','AED','AED'],
                      weights: [1, 1,1,1,1],
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
                      itemBuilder: (context, index){
                        BaseProductInfo info = presenter.productList[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text('${info.code} ${info.name??''}',textAlign:TextAlign.left,style: TextStyles.small,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(info.basePrice?.toString() ?? '0.00',textAlign:TextAlign.center,style: TextStyles.small,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(info.getActualShowStrByType(TaskType.Delivery),textAlign:TextAlign.center,style: TextStyles.small,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(info.discount?.toString() ?? '0.00',textAlign:TextAlign.center,style: TextStyles.small,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(info.netPrice?.toString() ?? '0.00',textAlign:TextAlign.center,style: TextStyles.small,),
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
                    )
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
                      itemBuilder: (context, index){
                        BaseProductInfo info = presenter.emptyProductList[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text('${info.code} ${info.name??''}',textAlign:TextAlign.left,style: TextStyles.small,),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(info.getActualShowStrByType(TaskType.EmptyReturn),textAlign:TextAlign.center,style: TextStyles.small,),
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
      })
    );
  }

}