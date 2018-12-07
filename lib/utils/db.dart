import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:meizi/model/model.dart';

class DbUtils {
  static Database db;

  final _lock = new Lock();

  Future initDB() async  {
    if (db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (db == null) {
          Directory documentsDirectory = await getApplicationDocumentsDirectory();
          String path = join(documentsDirectory.path, "meizi.db");
          db = await openDatabase(path, version: 2,
              onCreate: (Database db, int version) async {
                // When creating the db, create the table
                await db.execute(
                    "CREATE TABLE MeiziMen(id STRING PRIMARY KEY, title TEXT, category TEXT, thumb_url TEXT, image_url TEXT, favored BIT)");
              });
        }
      });
    }
  }

  Future<int> insert(String table, Map<String, dynamic> map) async {
    return db.insert(table, map);
  }

  Future<int> addMeizi(Meizi meizi) async {
    return await insert("MeiziMen", meizi.toMap());
  }

  Future<int> update(
      String table, Map map, [String whereSql, List<String> params]) async {
    return await db.update(table, map, where: whereSql, whereArgs: params);
  }

  Future<int> updateMeizi(Meizi meizi) async {
    int res = await update("MeiziMen", meizi.toMap(),
        "id = ?", [meizi.id]);
    print("Meizi updated $res");
    return res;
  }

  Future<int> delete(String table, String whereSql, List<String> params) async {
    return await db.delete(table, where: whereSql, whereArgs: params);
  }

  Future<int> deleteMeizi(String id) async {
    var res = await delete("MeiziMen", "id = ?", [id]);
    print("Meizi deleted $res");
    return res;
  }

  Future<dynamic> getOne(
      String table, String whereSql, List<String> params) async {
    List<Map> maps = await db.query(table,
        columns: ["*"], where: whereSql, whereArgs: params);
    if (maps.length == 0) return null;
    return maps.first;
  }

  Future<Meizi> getMeizi(String id) async {
    var res = await getOne("MeiziMen", "id = ?", [id]);
    if (res == null || res.length == 0) return null;
    return Meizi.fromDb(res[0]);
  }

  Future<List<dynamic>> getList(String table,
      [String whereSql, List<String> params]) async {
    List<Map> maps = await db.query(table,
        columns: ["*"], where: whereSql, whereArgs: params);
    return maps;
  }

  Future<List<Meizi>> getMeiziMen() async {
    var res = await getList("MeiziMen");
    if (res.length == 0) return null;
    return res.map((m) => Meizi.fromDb(m)).toList();
  }

  Future close() async => db.close();
}