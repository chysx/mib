
import 'package:mib/db/table/entity/dsd_t_shipment_item_entity.dart';
import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/7 10:34

@dao
abstract class DSD_T_ShipmentItem_Dao {
  @Query('SELECT * FROM DSD_T_ShipmentItem')
  Future<List<DSD_T_ShipmentItem_Entity>> findAll();

  @Query('SELECT * FROM DSD_T_ShipmentItem WHERE ShipmentNo = :ShipmentNo')
  Future<List<DSD_T_ShipmentItem_Entity>> findEntityByShipmentNo(String ShipmentNo);

  @insert
  Future<void> insertEntity(DSD_T_ShipmentItem_Entity entity);

  @insert
  Future<List<int>> insertEntityList(List<DSD_T_ShipmentItem_Entity> entityList);

  @delete
  Future<int> deleteEntity(List<DSD_T_ShipmentItem_Entity> entityList);

  @Query('DELETE FROM DSD_T_ShipmentItem WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM DSD_T_ShipmentItem')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(DSD_T_ShipmentItem_Entity entity);

  @Query('DELETE FROM DSD_T_ShipmentItem WHERE HeaderId = :HeaderId')
  Future<void> deleteByHeaderId(String HeaderId);

  @Query('DELETE FROM DSD_T_ShipmentItem WHERE ShipmentNo = :ShipmentNo AND ActionType = :ActionType')
  Future<void> deleteByShipmentNo(String ShipmentNo,String ActionType);

  @Query('SELECT * FROM DSD_T_ShipmentItem WHERE HeaderId = :HeaderId')
  Future<List<DSD_T_ShipmentItem_Entity>> findEntityByHeaderId(String HeaderId);

  @Query('SELECT * FROM DSD_T_ShipmentItem WHERE HeaderId = :HeaderId AND ProductCode = :ProductCode')
  Future<List<DSD_T_ShipmentItem_Entity>> findEntityByHeaderIdAndCode(String HeaderId,String ProductCode);

}
