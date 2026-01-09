import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verifacts/core/models/analysis.dart';
import 'package:verifacts/core/models/history.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'analysis_history';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'verifacts.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            url TEXT,
            analysis TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> saveAnalysis({
    String? text,
    String? url,
    required Analysis analysis,
  }) async {
    final db = await database;

    final existing = await findExistingAnalysis(text: text, url: url);
    if (existing != null) {
      return existing.id!;
    }

    final history = AnalysisHistory(
      text: text,
      url: url,
      analysis: analysis,
      createdAt: DateTime.now(),
    );

    return db.insert(_tableName, history.toMap());
  }

  static Future<AnalysisHistory?> findExistingAnalysis({
    String? text,
    String? url,
  }) async {
    final db = await database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (text != null && text.isNotEmpty && url != null && url.isNotEmpty) {
      whereClause = 'text = ? AND url = ?';
      whereArgs = [text, url];
    } else if (text != null && text.isNotEmpty) {
      whereClause = 'text = ? AND (url IS NULL OR url = "")';
      whereArgs = [text];
    } else if (url != null && url.isNotEmpty) {
      whereClause = 'url = ? AND (text IS NULL OR text = "")';
      whereArgs = [url];
    } else {
      return null;
    }

    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: whereClause,
      whereArgs: whereArgs,
      limit: 1,
    );

    if (results.isEmpty) return null;
    return AnalysisHistory.fromMap(results.first);
  }

  static Future<List<AnalysisHistory>> getHistory({int limit = 50}) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
      limit: limit,
    );

    return results.map((map) => AnalysisHistory.fromMap(map)).toList();
  }

  static Future<void> deleteHistory(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearHistory() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
