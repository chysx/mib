import 'package:flutter/material.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/ui/widget/drawer_widget.dart';
import 'package:mib/ui/widget/table_sticky_headers.dart';
import 'package:provider/provider.dart';

import 'inventory_presenter.dart';




/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-14 15:57

class InventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('INVENTORY'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              InventoryPresenter presenter = Provider.of<InventoryPresenter>(context);
              presenter.onClickRight(context);
            },
          )
        ],
      ),
      body: Consumer<InventoryPresenter>(
          builder: (context,presenter,_){
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: StickyHeadersTable(
              cellFit: BoxFit.none,
              cellDimensions: CellDimensions(
                contentCellWidth: 100.0,
                contentCellHeight: 50.0,
                stickyLegendWidth: 200.0,
                stickyLegendHeight: 50.0,
              ),
              columnsLength: presenter.columnHeaderList.length,
              rowsLength: presenter.rowHeaderList.length,
              columnsTitleBuilder: (i) => Text(presenter.columnHeaderList[i]),
              rowsTitleBuilder: (i) => Text(presenter.rowHeaderList[i]),
              contentCellBuilder: (i, j) => Text(presenter.data[j][i]),
              legendCell: Text('Poduct/SKU'),
              ),
          );
      }
      ),
      drawer: DrawerWidget(page: ConstantMenu.DARSHBOARD,),
    );
  }

}