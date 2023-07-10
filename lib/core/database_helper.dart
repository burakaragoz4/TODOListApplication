import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/core/model/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo_app.db');

    // Check if the database file exists
    final file = File(path);
    if (!await file.exists()) {
      // Create the database directory if it doesn't exist
      await Directory(dirname(path)).create(recursive: true);
    }

    // Open the database
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskName TEXT,
        taskIsSuccess INTEGER
      )
    ''');
  }

  Future<List<Task>> getTasks() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index]['id'],
        taskName: maps[index]['taskName'],
        taskIsSuccess: maps[index]['taskIsSuccess'] == 1 ? true : false,
      );
    });
  }

  Future<void> addTask(Task task) async {
    final Database db = await database;
    await db.insert('tasks', {
      'taskName': task.taskName,
      'taskIsSuccess': task.taskIsSuccess! ? 1 : 0,
    });
  }

  Future<void> removeTask(int id) async {
    final Database db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(Task task) async {
    final Database db = await database;
    await db.update(
      'tasks',
      {
        'taskName': task.taskName,
        'taskIsSuccess': task.taskIsSuccess! ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
