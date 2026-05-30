import '../../database/app_database.dart';

class AtividadeService {
  static const String _table = 'atividade';

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase().database;
    return await db.query(_table, orderBy: 'nome ASC');
  }
}