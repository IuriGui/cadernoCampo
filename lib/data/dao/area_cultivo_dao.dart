import '../database/app_database.dart';
import '../models/area_cultivo.dart';

class AreaCultivoDAO {
  static const String table = 'area_cultivo';

  Future<int> insertAreaCultivo(AreaCultivo area) async {
    final db = await AppDatabase().database;
    return await db.insert(table, area.toMap());
  }

  Future<List<AreaCultivo>> getAreasByLocal(int localId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'local_id = ? AND is_deleted = 0',
      whereArgs: [localId],
    );
    return maps.map((e) => AreaCultivo.fromMap(e)).toList();
  }

  Future<int> softDeleteAreaCultivo(int id) async {
    final db = await AppDatabase().database;
    return await db.transaction((txn) async {
      // Soft delete colheitas vinculadas às anotações desta área
      await txn.rawUpdate('''
        UPDATE colheita 
        SET is_deleted = 1 
        WHERE anotacao_id IN (SELECT id FROM anotacao WHERE area_cultivo_id = ?)
      ''', [id]);

      // Soft delete anotações vinculadas a esta área
      await txn.update(
        'anotacao',
        {'is_deleted': 1},
        where: 'area_cultivo_id = ?',
        whereArgs: [id],
      );

      // Soft delete a área de cultivo
      return await txn.update(
        table,
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<int> updateAreaCultivo(AreaCultivo area) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      area.toMap(),
      where: 'id = ?',
      whereArgs: [area.id],
    );
  }
}
