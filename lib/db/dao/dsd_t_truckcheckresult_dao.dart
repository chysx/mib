import 'package:floor/floor.dart';
import 'package:mib/db/table/entity/dsd_t_truckcheckresult_entity.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 16:26

@dao
abstract class DSD_T_TruckCheckResult_Dao {
  @Query('SELECT * FROM DSD_T_TruckCheckResult')
  Future<List<DSD_T_TruckCheckResult_Entity>> findAll();

  @insert
  Future<void> insertEntity(DSD_T_TruckCheckResult_Entity entity);

  @delete
  Future<int> deleteEntity(List<DSD_T_TruckCheckResult_Entity> entityList);

  @Query('DELETE FROM DSD_T_TruckCheckResult WHERE pid = :pid')
  Future<void> deleteById(String id);

  @Query('DELETE FROM DSD_T_TruckCheckResult')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(DSD_T_TruckCheckResult_Entity entity);

  @insert
  Future<List<int>> insertEntityList(List<DSD_T_TruckCheckResult_Entity> entityList);

}