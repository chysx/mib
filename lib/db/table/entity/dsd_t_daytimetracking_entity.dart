import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 15:23

@Entity(tableName: "DSD_T_DayTimeTracking")
class DSD_T_DayTimeTracking_Entity {
  @PrimaryKey(autoGenerate: true)
  int pid;
  String ID;
  String WorkDate;
  String UserCode;
  int TruckId;
  String TrackingTime;
  String TrackingType;
  double Longitude;
  double Latitude;
  int Odometer;
  String Signature;
  String SignImg;
  String CreateTime;
  String Dirty;
  String fileUploadFlag;


  DSD_T_DayTimeTracking_Entity(this.pid, this.ID, this.WorkDate, this.UserCode,
      this.TruckId, this.TrackingTime, this.TrackingType, this.Longitude,
      this.Latitude, this.Odometer, this.Signature, this.SignImg,
      this.CreateTime, this.Dirty, this.fileUploadFlag);

  DSD_T_DayTimeTracking_Entity.Empty();

}