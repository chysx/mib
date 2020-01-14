import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-10 11:23

@Entity(tableName: "DSD_M_ShipmentVanSalesRoute")
class DSD_M_ShipmentVanSalesRoute_Entity {
  @PrimaryKey(autoGenerate: true)
  int id;
  String ShipmentNo;
  String AccountNumber;
  String Status;
  String CreateTime;
  String NewAndStatus;
  String Dirty;

  DSD_M_ShipmentVanSalesRoute_Entity(this.id, this.ShipmentNo,
      this.AccountNumber, this.Status, this.CreateTime, this.NewAndStatus,
      this.Dirty);

  DSD_M_ShipmentVanSalesRoute_Entity.Empty();

}