import '../../database/app_database.dart';

class AreaCultivoService {
  static const String _table = 'area_cultivo';

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    return await db.insert(_table, data);
  }

  Future<List<Map<String, dynamic>>> getByLocal(int localId) async {
    final db = await AppDatabase().database;
    return await db.query(
      _table,
      where: 'local_id = ? AND is_deleted = 0',
      whereArgs: [localId],
    );
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
          SELECT id FROM anotacao WHERE area_cultivo_id = ?
        )
      ''', [id]);

      await txn.update('anotacao', {'is_deleted': 1},
          where: 'area_cultivo_id = ?', whereArgs: [id]);

      await txn.update(_table, {'is_deleted': 1},
          where: 'id = ?', whereArgs: [id]);
    });
  }
}