
import 'package:mib/db/table/entity/md_product_entity.dart';
import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/7 10:34

@dao
abstract class MD_Product_Dao {
  @Query('SELECT * FROM MD_Product')
  Future<List<MD_Product_Entity>> findAll();

  @Query('SELECT * FROM MD_Product WHERE ProductCode = :ProductCode')
  Future<MD_Product_Entity> findEntityByCode(String ProductCode);

  @Query('SELECT * FROM MD_Product WHERE EbMobile__IsEmpty__c = :EbMobile__IsEmpty__c')
  Future<List<MD_Product_Entity>> findEntityByEmpty(String EbMobile__IsEmpty__c);

  @insert
  Future<void> insertEntity(MD_Product_Entity entity);

  @delete
  Future<int> deleteEntity(List<MD_Product_Entity> entityList);

  @Query('DELETE FROM MD_Product WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM MD_Product')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(MD_Product_Entity entity);
}
