import 'package:mib/model/route_plan_info.dart';
import 'package:mib/res/strings.dart';
import 'package:mib/ui/page/route_plan/route_plan_presenter.dart';
import 'package:mib/ui/widget/drawer_widget.dart';
import 'package:mib/ui/widget/list_header_widget.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class RoutePlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var header = ListHeaderWidget(
      names: [
        IntlUtil.getString(context, Ids.route_plan_delivery_no),
        IntlUtil.getString(context, Ids.route_plan_type),
        IntlUtil.getString(context, Ids.route_plan_qty)
      ],
      weights: [1, 1, 1],
      aligns: [
        TextAlign.left,
        TextAlign.center,
        TextAlign.center,
      ],
    );

    return Scaffold(
      appBar: AppBar(
          title: GestureDetector(
        child: Text('ROUTE PLAN'),
      ) //Text('ROUTE PLAN'),
          ),
      body: Consumer<RoutePlanPresenter>(builder: (context, presenter, _) {
        return new Column(
          children: <Widget>[
            header,
            Expanded(
              child: ListView.separated(
                  itemCount: presenter.routePlanList.length,
                  separatorBuilder: (context, index){
                    return Divider(height: 2,);
                  },
                  itemBuilder: (context, index) {
                    RoutePlanInfo info = presenter.routePlanList[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              info.no,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              info.type,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              info.qty.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        );
      }),
    );
  }
}
