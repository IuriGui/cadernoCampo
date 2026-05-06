import '../database/app_database.dart';
import '../models/local.dart';

class LocalDAO {
  static const String table = 'local';

  Future<int> insertLocal(Local local) async {
    final db = await AppDatabase().database;
    return await db.insert(table, local.toMap());
  }

  Future<List<Local>> getLocaisByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'propriedade_id = ?',
      whereArgs: [propriedadeId],
    );
    return maps.map((e) => Local.fromMap(e)).toList();
  }

  Future<List<Local>> getTopThreeLocais(int propriedadeId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'propriedade_id = ?',
      whereArgs: [propriedadeId],
      limit: 3,
    );
    return maps.map((e) => Local.fromMap(e)).toList();
  }
}
