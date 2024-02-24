
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/Vedio.dart';

class MemoriesDatabase {
  static final MemoriesDatabase instance = MemoriesDatabase._init();
  static Database? _database;

  MemoriesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('memories.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final textType = 'TEXT NOT NULL';
    final boolType = 'INTEGER NOT NULL';
    final integerType = 'INTEGER';

    await db.execute('''
CREATE TABLE memories (
  id TEXT PRIMARY KEY,
  content_type INTEGER NOT NULL,
  content TEXT,
  created_at TEXT NOT NULL,
  last_modified TEXT,
  tags TEXT,
  location TEXT,
  emotion TEXT,
  is_private INTEGER NOT NULL
)
''');
  }

// Create
  Future<int> createMemory(Memory memory) async {
    final db = await instance.database;
    return await db.insert('memories', memory.toMap());
  }

// Read
  Future<Memory?> readMemory(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Memory.fromMap(maps.first);
    }
    return null;
  }

  //ReadAll
  Future<List<Memory>> readAllVideoMemories() async {
    final db = await instance.database;
    final maps = await db.query(
      'memories',
      where: 'content_type = ?',
      whereArgs: [ContentType.video.index], // Use the enum value's index
    );

    return maps.map((map) => Memory.fromMap(map)).toList(); // Convert to Vedio objects
  }

// Update
  Future<int> updateMemory(Memory memory) async {
    final db = await instance.database;
    return await db.update(
      'memories',
      memory.toMap(),
      where: 'id = ?',
      whereArgs: [memory.id],
    );
  }

// Delete
  Future<int> deleteMemory(String id) async {
    final db = await instance.database;
    return await db.delete(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
