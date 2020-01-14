import 'package:mib/application.dart';
import 'package:mib/common/constant.dart';
import 'package:mib/common/dictionary.dart';
import 'package:mib/db/table/entity/dsd_t_delivery_header_entity.dart';
import 'package:mib/event/EventNotifier.dart';
import 'package:mib/route/page_builder.dart';
import 'package:mib/ui/page/document/document_info.dart';
import 'package:mib/ui/page/print/print_module_type.dart';
import 'package:flutter/material.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/10/30 14:57

enum DocumentEvent {
  InitData,
}

class DocumentPresenter extends EventNotifier<DocumentEvent> {
  List<DocumentInfo> documentList = [];
  String shipmentNo;
  String accountNumber;
  String customerName;


  @override
  Future onEvent(DocumentEvent event, [dynamic data]) async {
    switch (event) {
      case DocumentEvent.InitData:
        await initData();
        break;
    }
    super.onEvent(event, data);
  }


  void setBundle(Map<String,dynamic> bundle){
    shipmentNo = bundle[FragmentArg.DELIVERY_SHIPMENT_NO];
  accountNumber = bundle[FragmentArg.DELIVERY_ACCOUNT_NUMBER];
  customerName = bundle[FragmentArg.TASK_CUSTOMER_NAME];
  }

  Future initData() async {
    await fillDocumentData();
  }

  Future fillDocumentData() async {
    documentList.clear();
    List<DSD_T_DeliveryHeader_Entity> deliveryList = await Application.database.tDeliveryHeaderDao.findEntityByCon(shipmentNo, accountNumber);
    for(DSD_T_DeliveryHeader_Entity entity in deliveryList) {
      DocumentInfo info = new DocumentInfo();
      info.deliveryNo = entity.DeliveryNo;
      if(entity.DeliveryType == TaskType.Delivery){
        info.name = 'Delivery Slip';
        info.printType = PrintModuleType.DELIVERY_SLIP;
      }else if(entity.DeliveryType == TaskType.VanSales){
        info.name = 'Sales Receipt';
        info.printType = PrintModuleType.SALE_RECEIPT;
      }
      documentList.add(info);

    }
  }

  void onItemClick(BuildContext context, DocumentInfo info) {
    Map<String,dynamic> bundle = {
      FragmentArg.DELIVERY_NO: info.deliveryNo,
      FragmentArg.DELIVERY_SHIPMENT_NO: shipmentNo,
      FragmentArg.DELIVERY_ACCOUNT_NUMBER: accountNumber,
      FragmentArg.TASK_CUSTOMER_NAME: customerName,
    };

    String page;
    if(info.printType == PrintModuleType.DELIVERY_SLIP){
      page = PageName.print_delivery_slip.toString();
    }else if (info.printType == PrintModuleType.SALE_RECEIPT) {
      page = PageName.print_van_sales_slip.toString();
    }
    Navigator.pushNamed(context, page,arguments: bundle);

  }

}