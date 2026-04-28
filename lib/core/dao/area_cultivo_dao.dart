import '../database/app_database.dart';
import '../models/area_cultivo.dart';

class AreaCultivoDAO {
  static const String table = 'areas_cultivo';

  Future<int> insertAreaCultivo(AreaCultivo area) async {
    final db = await AppDatabase().database;
    return await db.insert(table, area.toMap());
  }

  Future<List<AreaCultivo>> getAreasByLocal(int localId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'local_id = ?',
      whereArgs: [localId],
      orderBy: 'data_criacao DESC',
    );
    return maps.map((e) => AreaCultivo.fromMap(e)).toList();
  }

  Future<int> deleteAreaCultivo(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
