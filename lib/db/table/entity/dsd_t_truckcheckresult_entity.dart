import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 15:43

@Entity(tableName: "DSD_T_TruckCheckResult")
class DSD_T_TruckCheckResult_Entity {
  @PrimaryKey(autoGenerate: true)
  int id;
  String DayTrackingId;
  int DetailNo;
  int CheckItemId;
  String CheckResult;
  String CreateTime;
  String Dirty;

  DSD_T_TruckCheckResult_Entity(this.id, this.DayTrackingId, this.DetailNo,
      this.CheckItemId, this.CheckResult, this.CreateTime, this.Dirty);

  DSD_T_TruckCheckResult_Entity.Empty();

}