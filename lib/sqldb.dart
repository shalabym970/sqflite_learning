import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    _db ??= await initialDb();
    return _db;
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'wael.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 6, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE "notes"(
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "title" TEXT NOT NULL,
    "note" TEXT NOT NULL
    )
    ''');

    await batch.commit();
    print('========== create data base =============');
  }

  readData({required String sql}) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData({required String sql}) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData({required String sql}) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData({required String sql}) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('======== on upgrade ===========');
  }

  removeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'wael.db');
    await deleteDatabase(path);
  }

  /// SELECT
  /// DELETE
  /// UPDATE
  /// INSERT

  read({required String table}) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insert({required String table, required Map<String, Object> values}) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);
    return response;
  }

  update({
    required String table,
    required Map<String, Object> values,
    required String where,
  }) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, values, where: where);
    return response;
  }

  delete({required String table, required String where}) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: where);
    return response;
  }
}
