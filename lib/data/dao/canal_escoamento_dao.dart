import '../database/app_database.dart';
import '../models/canal.dart';

class CanalEscoamentoDAO {
  static const String table = 'canal_escoamento';

  Future<int> insertCanalEscoamento(CanalEscoamento canal) async {
    final db = await AppDatabase().database;
    return await db.insert(table, canal.toMap());
  }

  Future<List<CanalEscoamento>> getCanaisByProdutor(int produtorId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'produtor_id = ? AND is_deleted = 0',
      whereArgs: [produtorId],
    );
    return maps.map((e) => CanalEscoamento.fromMap(e)).toList();
  }

  Future<int> updateCanalEscoamento(CanalEscoamento canal) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      canal.toMap(),
      where: 'id = ?',
      whereArgs: [canal.id],
    );
  }

  Future<int> softDeleteCanalEscoamento(int id) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
