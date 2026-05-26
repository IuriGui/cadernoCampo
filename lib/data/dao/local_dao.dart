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
      where: 'propriedade_id = ? AND is_deleted = 0',
      whereArgs: [propriedadeId],
    );
    return maps.map((e) => Local.fromMap(e)).toList();
  }

  Future<List<Local>> getTopThreeLocais(int propriedadeId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'propriedade_id = ? AND is_deleted = 0',
      whereArgs: [propriedadeId],
      limit: 3,
    );
    return maps.map((e) => Local.fromMap(e)).toList();
  }

  Future<int> softDeleteLocal(int id) async {
    final db = await AppDatabase().database;
    return await db.transaction((txn) async {
      // Soft delete colheitas vinculadas às anotações das áreas deste local
      await txn.rawUpdate('''
        UPDATE colheita 
        SET is_deleted = 1 
        WHERE anotacao_id IN (
          SELECT id FROM anotacao WHERE area_cultivo_id IN (
            SELECT id FROM area_cultivo WHERE local_id = ?
          )
        )
      ''', [id]);

      // Soft delete anotações vinculadas às áreas deste local
      await txn.rawUpdate('''
        UPDATE anotacao 
        SET is_deleted = 1 
        WHERE area_cultivo_id IN (
          SELECT id FROM area_cultivo WHERE local_id = ?
        )
      ''', [id]);

      // Soft delete áreas de cultivo vinculadas a este local
      await txn.update(
        'area_cultivo',
        {'is_deleted': 1},
        where: 'local_id = ?',
        whereArgs: [id],
      );

      // Soft delete o próprio local
      return await txn.update(
        table,
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<int> updateLocal(Local local) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      local.toMap(),
      where: 'id = ?',
      whereArgs: [local.id],
    );
  }
}
