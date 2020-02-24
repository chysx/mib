import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 15:34

@Entity(tableName: "DSD_M_TruckCheckList")
class DSD_M_TruckCheckList_Entity {
  @PrimaryKey(autoGenerate: true)
  int pid;
  int Id;
  int ParentId;
  String Content;
  int Level;
  int InputType;
  String Description;
  String MustToDo;
  int Sequence;

  DSD_M_TruckCheckList_Entity(this.pid, this.Id, this.ParentId, this.Content,
      this.Level, this.InputType, this.Description, this.MustToDo,
      this.Sequence);

  DSD_M_TruckCheckList_Entity.Empty();


}