import '../database/app_database.dart';
import '../models/insumo.dart';

class InsumoDAO {
  static const String table = 'insumos';

  Future<List<Insumo>> getAll() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: 'produto ASC');
    return maps.map((e) => Insumo.fromMap(e)).toList();
  }
}
