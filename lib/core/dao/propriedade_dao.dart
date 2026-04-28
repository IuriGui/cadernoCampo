import '../database/app_database.dart';
import '../models/propriedade.dart';

class PropriedadeDAO {
  static const String table = 'propriedades';

  Future<int> insertPropriedade(Propriedade propriedade) async {
    final db = await AppDatabase().database;
    return await db.insert(table, propriedade.toMap());
  }

  Future<List<Propriedade>> getAllPropriedades() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps.map((e) => Propriedade.fromMap(e)).toList();
  }

  Future<Propriedade?> getFirstPropriedade() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table, limit: 1);
    if (maps.isNotEmpty) {
      return Propriedade.fromMap(maps.first);
    }
    return null;
  }

  Future<Propriedade?> getPropriedadeByUsuario(int usuarioId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Propriedade.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePropriedade(Propriedade propriedade) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      propriedade.toMap(),
      where: 'id = ?',
      whereArgs: [propriedade.id],
    );
  }
}
