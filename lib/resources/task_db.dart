import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/task.dart';
import '../model/group.dart';

class TaskDB {
  static final TaskDB _instance = TaskDB.internal();
  factory TaskDB() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await init();
    }
    return _db;
  }

  TaskDB.internal();

  //############################################################################################################//

  final String tasksTableName = "Tasks";
  final String tasksColumnId = "id";
  final String tasksColumnTitle = "title";
  final String tasksColumnDone = "done";
  final String tasksColumnGroupId = "groupId";

  final String groupsTableName = "Groups";
  final String groupsColumnId = "id";
  final String groupsColumnName = "name";
  final String groupsColumnColor = "color";

  //############################################################################################################//

  //Initialization
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "tasks.db");
    var ourDB = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDB, int version) {
        newDB.execute("""
          CREATE TABLE $tasksTableName (
            $tasksColumnId INTEGER PRIMARY KEY NOT NULL,
            $tasksColumnTitle TEXT NOT NULL,
            $tasksColumnDone INTEGER NOT NULL,
            $tasksColumnGroupId INTEGER NOT NULL
          )
        """);
        newDB.execute("""
          CREATE TABLE $groupsTableName (
            $groupsColumnId INTEGER PRIMARY KEY NOT NULL,
            $groupsColumnName TEXT NOT NULL,
            $groupsColumnColor INTEGER NOT NULL
          )
        """);
      },
    );
    return ourDB;
  }

  //############################################################################################################//

  //Insertion
  Future<int> save(String table, dynamic item) async {
    var dbClient = await db;
    int res = await dbClient.insert(table, item.toMap());
    return res;
  }

  //############################################################################################################//

  //Read
  Future<List> getAll(String table) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $table");
    return res.toList();
  }

  Future<dynamic> getItem(String table, int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $table WHERE id = $id");
    if (res == null || res.length == 0) return null;
    if(table == groupsTableName) return Group.fromMap(res.first);
    else if(table == tasksTableName) return Task.fromMap(res.first);
  }

  Future<Task> getTask(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tasksTableName WHERE id = $id");
    if (res == null || res.length == 0) return null;
    return Task.fromMap(res.first);
  }

  Future<Group> getGroup(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $groupsTableName WHERE id = $id");
    if (res == null || res.length == 0) return null;
    return Group.fromMap(res.first);
  }

  Future<int> getCount(String table) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $table"));
  }

  //############################################################################################################//

  //Update
  Future<int> update(String table, dynamic item) async {
    var dbClient = await db;
    return await dbClient.update(table, item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }

  //############################################################################################################//

  //Delete
  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tasksTableName, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteGroup(int id) async {
    var dbClient = await db;
    await dbClient.delete(groupsTableName, where: "id = ?", whereArgs: [id]);
    return await dbClient.delete(tasksTableName, where: "$tasksColumnGroupId = ?", whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    await dbClient.delete(groupsTableName);
    return await dbClient.delete(tasksTableName);
  }

  //############################################################################################################//

  //Close
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
