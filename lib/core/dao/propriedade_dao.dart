import '../database/app_database.dart';
import '../models/propriedade.dart';

class PropriedadeDAO {
  static const String table = 'propriedade';

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
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.* FROM $table p
      JOIN produtor_propriedade pp ON p.id = pp.propriedade_id
      JOIN produtor pr ON pp.produtor_id = pr.id
      WHERE pr.usuario_id = ?
      LIMIT 1
    ''', [usuarioId]);

    if (maps.isNotEmpty) {
      return Propriedade.fromMap(maps.first);
    }
    return null;
  }

  Future<Propriedade?> getPropriedadeById(int id) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
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
