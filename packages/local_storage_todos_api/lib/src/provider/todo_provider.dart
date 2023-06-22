import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_api/todo_api.dart';

final class TodoProvider {
  late Database db;

  Future<void> open(String path) async {
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        create table $tableTodo (
        $columnId text primary key,
        $columnText text not null,
        $columnImportance text not null,
        $columnDeadline text,
        $columnDone text not null,
        $columnColor text,
        $columnCreatedAt text not null,
        $columnChangedAt text not null,
        $columnLastUpdatedBy text not null)
        ''');
      },
    );
  }

  Future<void> insert(Todo todo) async {
    await db.insert(tableTodo, todo.toJson());
  }

  Future<Todo?> getTodo(String id) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableTodo,
      columns: [
        columnId,
        columnText,
        columnImportance,
        columnDeadline,
        columnDone,
        columnColor,
        columnCreatedAt,
        columnChangedAt,
        columnLastUpdatedBy,
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<void> delete(String id) async {
    db.delete(
      tableTodo,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    Future<void> update(Todo todo) async {
      db.update(
        tableTodo,
        todo.toJson(),
        where: '$columnId = ?',
        whereArgs: [todo.id],
      );
    }

    Future<void> close() async => db.close();
  }
}