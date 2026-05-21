import '../database/app_database.dart';
import '../models/cultura.dart';

class CulturaDAO {
  static const String table = 'cultura';

  Future<List<Cultura>> getAll() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: 'nome ASC');
    return maps.map((e) => Cultura.fromMap(e)).toList();
  }
}
