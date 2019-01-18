import 'task_db.dart';
import '../model/task.dart';
import '../model/group.dart';

class Repository {
  final db = TaskDB();

  Future<int> save(String table, dynamic item) {
    return db.save(table, item);
  }

  Future<List> getAll(String table) {
    return db.getAll(table);
  }

  Future<dynamic> getItem(String table, int id) {
    return db.getItem(table, id);
  }

  Future<Task> getTask(int id) {
    return db.getTask(id);
  }

  Future<Group> getGroup(int id) {
    return db.getGroup(id);
  }

  Future<int> getCount(String table) {
    return db.getCount(table);
  }

  Future<int> update(String table, dynamic item) {
    return db.update(table, item);
  }

  Future<int> deleteGroup(int id) {
    return db.deleteGroup(id);
  }

  Future<int> deleteTask(int id) {
    return db.deleteTask(id);
  }

  Future<int> deleteAll() {
    return db.deleteAll();
  }
}