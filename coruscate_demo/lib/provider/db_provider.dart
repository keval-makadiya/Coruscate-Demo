import 'dart:io';

import 'package:coruscate_demo/models/Employee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:dio/dio.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();

    final path = join(directory.path, 'manage_employee.db');

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Employee('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'address TEXT'
          ')');
    });
  }

  createEmployee(Employee newEmployee) async {
//    await deleteAllEmployees();
    final db = await database;
    final res = await db.insert('Employee', newEmployee.toJson());
    return res;
  }

  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');
    return res;
  }

  Future<List<Employee>> getAllEmployees() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Employee");

    List<Employee> list = res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];

    return list;
  }
}
