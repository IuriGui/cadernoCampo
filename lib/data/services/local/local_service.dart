import '../../database/app_database.dart';

class LocalService {
  static const String _table = 'local';

  Future<List<Map<String, dynamic>>> getByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    return await db.query(
      _table,
      where: 'propriedade_id = ? AND is_deleted = 0',
      whereArgs: [propriedadeId],
    );
  }

  Future<Map<String, dynamic>> get(int id) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      _table,
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [id],
    );
    return rows.first;
  }

  Future<List<Map<String, dynamic>>> getTopThree(int propriedadeId) async {
    final db = await AppDatabase().database;
    return await db.query(
      _table,
      where: 'propriedade_id = ? AND is_deleted = 0',
      whereArgs: [propriedadeId],
      limit: 3,
    );
  }

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    return await db.insert(_table, data);
  }

  Future<void> update(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    await db.update(_table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> softDelete(int id) async {
    final db = await AppDatabase().database;
    await db.transaction((txn) async {
      await txn.rawUpdate('''
        UPDATE colheita SET is_deleted = 1
        WHERE anotacao_id IN (
          SELECT id FROM anotacao WHERE area_cultivo_id IN (
            SELECT id FROM area_cultivo WHERE local_id = ?
          )
        )
      ''', [id]);

      await txn.rawUpdate('''
        UPDATE anotacao SET is_deleted = 1
        WHERE area_cultivo_id IN (
          SELECT id FROM area_cultivo WHERE local_id = ?
        )
      ''', [id]);

      await txn.update('area_cultivo', {'is_deleted': 1},
          where: 'local_id = ?', whereArgs: [id]);

      await txn.update(_table, {'is_deleted': 1},
          where: 'id = ?', whereArgs: [id]);
    });
  }
}