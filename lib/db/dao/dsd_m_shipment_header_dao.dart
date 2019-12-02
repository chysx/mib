import 'package:mib/db/table/entity/app_config_entity.dart';
import 'package:mib/db/table/entity/dsd_m_delivery_header_entity.dart';
import 'package:mib/db/table/entity/dsd_m_shipment_header_entity.dart';
import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/7 10:34

@dao
abstract class DSD_M_ShipmentHeader_Dao {
  @Query('SELECT * FROM DSD_M_ShipmentHeader')
  Future<List<DSD_M_ShipmentHeader_Entity>> findAll();

  @Query('SELECT * FROM DSD_M_ShipmentHeader WHERE ShipmentNo = :ShipmentNo AND Valid = :Valid')
  Future<DSD_M_ShipmentHeader_Entity> findEntityByShipmentNo(String ShipmentNo,String Valid);

  @insert
  Future<void> insertEntity(DSD_M_ShipmentHeader_Entity entity);

  @delete
  Future<int> deleteEntity(List<DSD_M_ShipmentHeader_Entity> entityList);

  @Query('DELETE FROM DSD_M_ShipmentHeader WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM DSD_M_ShipmentHeader')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(DSD_M_ShipmentHeader_Entity entity);


  @Query('SELECT * FROM DSD_M_ShipmentHeader WHERE ShipmentDate = :ShipmentDate AND Valid = :Valid')
  Future<List<DSD_M_ShipmentHeader_Entity>> findByByToday(String ShipmentDate,String Valid);


}
