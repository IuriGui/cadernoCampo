import '../database/app_database.dart';
import '../models/atividade.dart';

class AtividadeDAO {
  static const String table = 'atividades';

  Future<List<Atividade>> getAll() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table, orderBy: 'nome ASC');
    return maps.map((e) => Atividade.fromMap(e)).toList();
  }
}
