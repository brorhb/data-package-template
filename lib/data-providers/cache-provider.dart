import 'dart:io';
import 'package:your_package_name_here/models/Cache.dart';
import 'package:your_package_name_here/models/Item.dart';
import 'package:your_package_name_here/models/Source.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CacheProvider implements Source, Cache {
  String _tablename = "your_table_name";
  Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await init();
      return _database;
    }
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, '$_tablename.db');
    final Database db = await openDatabase(path,
        version: 1,
        onCreate: (newDb, version) => _createDb(newDb, version),
        onUpgrade: (db, prevVersion, newVersion) =>
            _migration(db, prevVersion, newVersion),
        onDowngrade: (db, prevVersion, newVersion) =>
            _migration(db, prevVersion, newVersion));
    return db;
  }

  void _migration(Database db, int prevVersion, int newVersion) async {
    await db.rawQuery('ALTER TABLE $_tablename RENAME TO ${_tablename}_old');
    _createDb(db, newVersion);
    await db.rawQuery('DROP TABLE ${_tablename}_old');
  }

  void _createDb(Database newDb, int version) {
    newDb.execute("""
      CREATE TABLE $_tablename (
        id INTEGER PRIMARY KEY,
        title TEXT
      );
    """);
  }

  @override
  Future clear() async {
    final Database db = await database;
    return db.delete(_tablename);
  }

  @override
  Future<int> delete({int itemId}) async {
    final Database db = await database;
    return await db.delete(_tablename, where: 'id = ?', whereArgs: [itemId]);
  }

  @override
  Future<List> fetch() async {
    final Database db = await database;
    List<Map<String, dynamic>> rawList = await db.query(_tablename);
    if (rawList != null && rawList.length > 0) {
      return rawList.map((item) => Item.fromJson(item)).toList();
    }
    return null;
  }

  @override
  Future<int> insert({List items}) async {
    Database db = await database;
    Batch batch = db.batch();
    for (var item in items) {
      batch.insert(_tablename, item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true, continueOnError: false);
    return items.length;
  }
}

CacheProvider cacheProvider = CacheProvider();
