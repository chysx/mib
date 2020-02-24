import 'package:floor/floor.dart';
import 'package:mib/db/table/entity/dsd_t_daytimetracking_entity.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-02-12 16:14


@dao
abstract class DSD_T_DayTimeTracking_Dao {
  @Query('SELECT * FROM DSD_T_DayTimeTracking')
  Future<List<DSD_T_DayTimeTracking_Entity>> findAll();

  @Query('SELECT * FROM DSD_T_DayTimeTracking WHERE WorkDate = :WorkDate AND UserCode = :UserCode AND TrackingType = :TrackingType ')
  Future<List<DSD_T_DayTimeTracking_Entity>> findEntityByCondition(String WorkDate,String UserCode,String TrackingType);

  @insert
  Future<void> insertEntity(DSD_T_DayTimeTracking_Entity entity);

  @delete
  Future<int> deleteEntity(List<DSD_T_DayTimeTracking_Entity> entityList);

  @Query('DELETE FROM DSD_T_DayTimeTracking WHERE pid = :pid')
  Future<void> deleteById(String id);

  @Query('DELETE FROM DSD_T_DayTimeTracking')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(DSD_T_DayTimeTracking_Entity entity);
}