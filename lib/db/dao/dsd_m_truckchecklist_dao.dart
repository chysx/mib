import 'package:floor/floor.dart';
import 'package:mib/db/table/entity/dsd_m_truckchecklist_entity.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 16:05

@dao
abstract class DSD_M_TruckCheckList_Dao {
  @Query('SELECT * FROM DSD_M_TruckCheckList')
  Future<List<DSD_M_TruckCheckList_Entity>> findAll();

  @Query('SELECT * FROM DSD_M_TruckCheckList WHERE parentId = :parentId')
  Future<List<DSD_M_TruckCheckList_Entity>> findEntityByParentId(String parentId);

  @Query('SELECT * FROM DSD_M_TruckCheckList id = :id')
  Future<DSD_M_TruckCheckList_Entity> findEntityById(String id);


  @insert
  Future<void> insertEntity(DSD_M_TruckCheckList_Entity entity);

  @delete
  Future<int> deleteEntity(List<DSD_M_TruckCheckList_Entity> entityList);

  @Query('DELETE FROM DSD_M_TruckCheckList WHERE pid = :pid')
  Future<void> deleteById(String id);

  @Query('DELETE FROM DSD_M_TruckCheckList')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(DSD_M_TruckCheckList_Entity entity);
}