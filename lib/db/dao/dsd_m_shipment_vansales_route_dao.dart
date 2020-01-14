import 'package:floor/floor.dart';
import 'package:mib/db/table/entity/dsd_m_shipment_sales_route_entity.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2020-01-10 11:40

@dao
abstract class DSD_M_ShipmentVanSalesRoute_Dao {
  @Query('SELECT * FROM DSD_M_ShipmentVanSalesRoute')
  Future<List<DSD_M_ShipmentVanSalesRoute_Entity>> findAll();

  @Query('SELECT * FROM DSD_M_ShipmentVanSalesRoute WHERE ShipmentNo = :ShipmentNo')
  Future<DSD_M_ShipmentVanSalesRoute_Entity> findEntityByDeliveryNo(String ShipmentNo);

  @insert
  Future<void> insertEntity(DSD_M_ShipmentVanSalesRoute_Entity entity);

  @delete
  Future<int> deleteEntity(List<DSD_M_ShipmentVanSalesRoute_Entity> entityList);

  @Query('DELETE FROM DSD_M_ShipmentVanSalesRoute WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM DSD_M_ShipmentVanSalesRoute')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(DSD_M_ShipmentVanSalesRoute_Entity entity);

  @Query('SELECT * FROM DSD_M_ShipmentVanSalesRoute WHERE shipmentNo = :shipmentNo AND accountNumber = :accountNumber')
  Future<List<DSD_M_ShipmentVanSalesRoute_Entity>> findEntityByCon(String shipmentNo,String accountNumber);
}