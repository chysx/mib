import 'package:mib/model/base_product_info.dart';
import 'package:mib/res/styles.dart';
import 'package:mib/ui/page/vansales/vansales_presenter.dart';
import 'package:mib/ui/widget/fold_widget.dart';
import 'package:mib/ui/widget/list_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-13 11:20

class VanSalesPage extends StatelessWidget {
  List<TextEditingController> csList = [];
  List<TextEditingController> eaList = [];
  List<TextEditingController> emptyList = [];

  void initControllerEmpty(VanSalesPresenter presenter) {
//    if(csList.length > 0) return ;
    emptyList.clear();
    for (BaseProductInfo info in presenter.emptyProductList) {
      TextEditingController controller = TextEditingController.fromValue(TextEditingValue(
        // 设置内容
          text: (info.actualCs ?? '').toString(),
          // 保持光标在最后
          selection: TextSelection.fromPosition(
              TextPosition(affinity: TextAffinity.downstream, offset: (info.actualCs ?? 0).toString().length))));
      controller.addListener(() {
        info.actualCs = int.tryParse(controller.text);
        presenter.onEvent(VanSalesEvent.OnInput, info);
      });
      emptyList.add(controller);
    }
  }

  void initControllerCs(VanSalesPresenter presenter) {
//    if(csList.length > 0) return ;
    csList.clear();
    for (BaseProductInfo info in presenter.productList) {
      TextEditingController controller = TextEditingController.fromValue(TextEditingValue(
        // 设置内容
          text: (info.actualCs ?? '').toString(),
          // 保持光标在最后
          selection: TextSelection.fromPosition(
              TextPosition(affinity: TextAffinity.downstream, offset: (info.actualCs ?? 0).toString().length))));

      controller.addListener(() {
        info.actualCs = int.tryParse(controller.text);
        presenter.onEvent(VanSalesEvent.OnInput, info);
      });
      csList.add(controller);
    }
  }

  void initControllerEa(VanSalesPresenter presenter) {
//    if(eaList.length > 0) return ;
    eaList.clear();
    for (BaseProductInfo info in presenter.productList) {
      TextEditingController controller = TextEditingController.fromValue(TextEditingValue(
        // 设置内容
          text: (info.actualEa ?? '').toString(),
          // 保持光标在最后
          selection: TextSelection.fromPosition(
              TextPosition(affinity: TextAffinity.downstream, offset: (info.actualEa ?? 0).toString().length))));
      controller.addListener(() {
        info.actualEa = int.tryParse(controller.text);
        presenter.onEvent(VanSalesEvent.OnInput, info);
      });
      eaList.add(controller);
    }
  }

  Widget createListHeaderWidget(VanSalesPresenter presenter) {
    return ListHeaderWidget(
      names: ['Product', 'Stock', 'SellAble','Sales'],
      supNames: ['', 'CS/EA', 'CS/EA', 'CS/EA'],
      weights: [2, 1, 1,1],
      aligns: [
        TextAlign.left,
        TextAlign.center,
        TextAlign.center,
        TextAlign.center,
      ],
      isCheck: false,
      onChange: (value) {
        presenter.onEvent(VanSalesEvent.SelectOrCancelAll, value);
      },
    );
  }

  Widget createListFooterWidget(VanSalesPresenter presenter) {
    return ListHeaderWidget(
      names: [
        'toal:',
        BaseProductInfo.getPlanTotal(presenter.productList),
        BaseProductInfo.getActualTotal(presenter.productList),
        ''
      ],
      supNames: ['', '', '', ''],
      weights: [2, 1, 1, 1],
      aligns: [
        TextAlign.left,
        TextAlign.center,
        TextAlign.center,
        TextAlign.center,
      ],
      onChange: (value) {},
    );
  }

  Widget createListHeaderEmptyWidget(VanSalesPresenter presenter) {
    return ListHeaderWidget(
      names: ['Product', 'Stock', 'Actual'],
      supNames: ['', '', ''],
      weights: [2, 1, 1],
      aligns: [
        TextAlign.left,
        TextAlign.center,
        TextAlign.center,
      ],
      isCheck: false,
      onChange: (value) {
        presenter.onEvent(VanSalesEvent.SelectOrCancelEmptyAll, value);
      },
    );
  }

  Widget createListFooterEmptyWidget(VanSalesPresenter presenter) {
    return ListHeaderWidget(
      names: [
        'toal:',
        BaseProductInfo.getPlanTotal(presenter.emptyProductList),
        BaseProductInfo.getActualTotal(presenter.emptyProductList),
        ''
      ],
      supNames: ['', '', '', ''],
      weights: [2, 1, 1, 1],
      aligns: [
        TextAlign.left,
        TextAlign.center,
        TextAlign.center,
        TextAlign.center,
      ],
      onChange: (value) {
        presenter.onEvent(VanSalesEvent.SelectOrCancelAll,value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('VANSALES'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              VanSalesPresenter presenter = Provider.of<VanSalesPresenter>(context);
              presenter.onClickRight(context);
            },
          )
        ],
      ),
      body: Consumer<VanSalesPresenter>(
        builder: (context, presenter, _) {
          initControllerCs(presenter);
          initControllerEa(presenter);
          initControllerEmpty(presenter);
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FoldWidget(
                  msg: 'PRODUCTS',
                  child: Column(
                    children: <Widget>[
                      createListHeaderWidget(presenter),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: presenter.productList.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 2,
                            );
                          },
                          itemBuilder: (context, index) {
                            BaseProductInfo info = presenter.productList[index];
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${info.code} ${info.name}',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${info.plannedCs}/${info.plannedEa}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${info.salesAbleCs}/${info.salesAbleEa}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            height: 36,
                                            child: Theme(
                                              data: ThemeData(primaryColor: Colors.grey),
                                              child: TextField(
                                                controller:
                                                csList.length > 0 ? csList[index] : new TextEditingController(),
                                                enabled: true,
                                                keyboardType: TextInputType.number,
                                                style: TextStyles.normal,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 6, bottom: 6, left: 2, right: 2),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 2),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 36,
                                            child: Theme(
                                              data: ThemeData(primaryColor: Colors.grey),
                                              child: TextField(
                                                controller:
                                                eaList.length > 0 ? eaList[index] : new TextEditingController(),
                                                enabled: true,
                                                keyboardType: TextInputType.number,
                                                style: TextStyles.normal,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 6, bottom: 6, left: 2, right: 2),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Checkbox(
                                            value: info.isCheck,
                                            onChanged: (value){
                                              presenter.onEvent(VanSalesEvent.SelectOrCancel,info);
                                            },
                                          ),
                                        ),

                                        Positioned(
                                          right: 0,
                                          bottom: 16,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
//                                              presenter.showReasonDialog(context, info);
                                            },
                                            child: Offstage(
//                                                offstage: info.isEqual(),
                                                offstage: true,
                                                child: Icon(Icons.info,color: info.isRedReasonIcon() ? Colors.red : Colors.grey,size: 18,)),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
//                          createListFooterWidget(presenter)
                    ],
                  ),
                ),
                FoldWidget(
                  msg: 'EMPTY PRODUCTS',
                  child: Column(
                    children: <Widget>[
                      createListHeaderEmptyWidget(presenter),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: presenter.emptyProductList.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 2,
                            );
                          },
                          itemBuilder: (context, index) {
                            BaseProductInfo info = presenter.emptyProductList[index];
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${info.code} ${info.name}',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${info.plannedCs}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            height: 36,
                                            child: Theme(
                                              data: ThemeData(primaryColor: Colors.grey),
                                              child: TextField(
                                                controller: emptyList.length > 0
                                                    ? emptyList[index]
                                                    : new TextEditingController(),
                                                keyboardType: TextInputType.number,
                                                style: TextStyles.normal,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 6, bottom: 6, left: 2, right: 2),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Checkbox(
                                            value: info.isCheck,
                                            onChanged: (value){
                                              presenter.onEvent(VanSalesEvent.SelectOrCancel,info);
                                            },
                                          ),
                                        ),

                                        Positioned(
                                          right: 0,
                                          bottom: 16,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
//                                              presenter.showReasonDialog(context, info);
                                            },
                                            child: Offstage(
//                                                offstage: info.isEqual(),
                                                offstage: true,
                                                child: Icon(Icons.info,color: info.isRedReasonIcon() ? Colors.red : Colors.grey,size: 18,)),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
//                      createListFooterEmptyWidget(presenter)
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
