
import 'package:mib/db/table/entity/md_account_entity.dart';
import 'package:floor/floor.dart';

/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019/8/7 10:34

@dao
abstract class MD_Account_Dao {
  @Query('SELECT * FROM MD_Account')
  Future<List<MD_Account_Entity>> findAll();

  @Query('SELECT * FROM MD_Account WHERE AccountNumber = :AccountNumber')
  Future<MD_Account_Entity> findEntityByAccountNumber(String AccountNumber);

  @insert
  Future<void> insertEntity(MD_Account_Entity entity);

  @delete
  Future<int> deleteEntity(List<MD_Account_Entity> entityList);

  @Query('DELETE FROM MD_Account WHERE id = :id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM MD_Account')
  Future<void> deleteAll();

  @update
  Future<int> updateEntity(MD_Account_Entity entity);
}
