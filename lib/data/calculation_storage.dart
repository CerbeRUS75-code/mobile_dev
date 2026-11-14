import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class CalculationStorage {
  Future<Database>? _database;

  Future<Database> get database => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final directory = await getDatabasesPath();
    return openDatabase(
      path.join(directory, 'calculations.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE calculations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            channels INTEGER NOT NULL,
            frequency INTEGER NOT NULL,
            depth INTEGER NOT NULL,
            duration REAL NOT NULL,
            consent INTEGER NOT NULL,
            bytes REAL NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> saveCalculation({
    required int channels,
    required int frequency,
    required int depth,
    required double duration,
    required double bytes,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('channels', channels);
    await preferences.setInt('frequency', frequency);
    await preferences.setInt('depth', depth);
    await preferences.setDouble('duration', duration);
    await preferences.setBool('consent', true);
    await preferences.setDouble('bytes', bytes);
    final db = await database;
    await db.insert('calculations', {
      'channels': channels,
      'frequency': frequency,
      'depth': depth,
      'duration': duration,
      'consent': 1,
      'bytes': bytes,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, Object>?> loadLast() async {
    final preferences = await SharedPreferences.getInstance();
    final channels = preferences.getInt('channels');
    final frequency = preferences.getInt('frequency');
    final depth = preferences.getInt('depth');
    final duration = preferences.getDouble('duration');
    final consent = preferences.getBool('consent');
    final bytes = preferences.getDouble('bytes');
    if (channels == null ||
        frequency == null ||
        depth == null ||
        duration == null ||
        consent == null ||
        bytes == null) {
      return null;
    }
    return {
      'channels': channels,
      'frequency': frequency,
      'depth': depth,
      'duration': duration,
      'consent': consent,
      'bytes': bytes,
    };
  }

  Future<List<Map<String, Object?>>> loadHistory() async {
    final db = await database;
    return db.query('calculations', orderBy: 'id DESC');
  }
}
