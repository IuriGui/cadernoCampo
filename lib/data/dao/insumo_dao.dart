import '../database/app_database.dart';
import '../models/insumo.dart';

class InsumoDAO {
  static const String table = 'insumo';

  Future<List<Insumo>> getInsumosByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'propriedade_id = ?',
      whereArgs: [propriedadeId],
      orderBy: 'produto ASC',
    );
    return maps.map((e) => Insumo.fromMap(e)).toList();
  }

  Future<List<Insumo>> getAll() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: 'produto ASC');
    return maps.map((e) => Insumo.fromMap(e)).toList();
  }

  Future<int> insertInsumo(Insumo insumo) async {
    final db = await AppDatabase().database;
    return await db.insert(table, insumo.toMap());
  }
}
