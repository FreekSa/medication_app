import 'dart:io';

import 'package:medication_app/models/medicationTaken.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/log.dart';

class CreateDatabase {
  CreateDatabase._privateConstructor();
  static final CreateDatabase instance = CreateDatabase._privateConstructor();
  static Database? _database;
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'logs.db');
    return await openDatabase(path,
        version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE logsComplaints(
          id TEXT PRIMARY KEY,
          title TEXT,
          date TEXT
      );
      ''');
    await db.execute('''
      CREATE TABLE logsMedicationTaken(
          id TEXT PRIMARY KEY,
          taken INT,
          date TEXT
      );
      ''');
  }

  listTables() async {
    Database db = await instance.database;
    (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
      print(row);
    });
  }

  Future<List<Log>> GetComplaintLogs() async {
    Database db = await instance.database;
    var logs = await db.query('logsComplaints', orderBy: 'date');
    List<Log> logsList =
        logs.isNotEmpty ? logs.map((c) => Log.fromMap(c)).toList() : [];
    return logsList;
  }

  Future<int> AddComplaintLog(Log log) async {
    Database db = await instance.database;
    return await db.insert('logsComplaints', log.toMap());
  }

  Future<int> RemoveComplaintLog(String id) async {
    Database db = await instance.database;
    return await db.delete('logsComplaints', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> UpdateComplaintLog(Log log) async {
    Database db = await instance.database;
    return await db.update('logsComplaints', log.toMap(),
        where: "id = ?", whereArgs: [log.id]);
  }

  Future<List<MedicationTaken>> GetMedicationTakenLogs() async {
    Database db = await instance.database;
    var taken = await db.query('logsMedicationTaken', orderBy: 'date');
    List<MedicationTaken> takenList = taken.isNotEmpty
        ? taken.map((c) => MedicationTaken.fromMap(c)).toList()
        : [];
    return takenList;
  }

  Future<int> AddMedicationTakenLog(MedicationTaken taken) async {
    Database db = await instance.database;
    return await db.insert('logsMedicationTaken', taken.toMap());
  }
}
