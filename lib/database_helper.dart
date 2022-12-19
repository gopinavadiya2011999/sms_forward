import 'package:auto_forward_sms/sms_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static const _dbName = 'smsForwarding';
  static const _dbVersion = 1;

  static const tableName = 'smsData';

  static const smsId = 'smsId';
  static const text = 'text';
  static const switchOn = 'switchOn';

  DatabaseHelper._privateConstructor();


  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName(
    $smsId INTEGER  NOT NULL,
    $text TEXT NOT NULL,
    $switchOn INTEGER NOT NULL
    )''');
  }


  Future<int> insert(SmsModel shoppingModel) async {
    Database database = await instance.database;
    return await database.insert(tableName, {
      'smsId': shoppingModel.smsId,
      'text': shoppingModel.text,
      'switchOn': shoppingModel.switchOn
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database database = await instance.database;
    return await database.query(tableName);
  }


  Future<List<Map<String, dynamic>>> queryRows(shopName) async {
    Database database = await instance.database;
    return await database.query(tableName,
        where: "$shopName LIKE '%$shopName%");
  }

  Future<int?> queryRowCount() async {
    Database database = await instance.database;
    return Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }


  Future<int> update(SmsModel shoppingModel) async {
    Database database = await instance.database;
    if (kDebugMode) {
      print("sms model :: ${shoppingModel.smsId} || sms text :: ${shoppingModel
          .text} || sms switch:: ${shoppingModel.switchOn}");
    }
    return database.update(tableName, shoppingModel.toMap(),
        where: "smsId = ?", whereArgs: [shoppingModel.smsId]);
  }


  Future<int> delete(SmsModel shoppingModel) async {
    Database database = await instance.database;

    return database.delete(tableName,
        where: "smsId = ?", whereArgs: [shoppingModel.smsId]);
  }
}
