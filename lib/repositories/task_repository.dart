import '../database/connection_db.dart';
import '../models/task.dart';

class TaskRepository {

  Future<int> insert(Task task) async {
    final db = await ConnectionDb.instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAll() async {
    final db = await ConnectionDb.instance.database;

    final result = await db.query('tasks');

    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<Task?> getById(int id) async {
    final db = await ConnectionDb.instance.database;

    final result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return Task.fromMap(result.first);
  }

  Future<int> update(Task task) async {
    final db = await ConnectionDb.instance.database;

    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await ConnectionDb.instance.database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
