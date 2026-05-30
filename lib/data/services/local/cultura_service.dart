import '../../database/app_database.dart';

class CulturaService {

  static const String _table = 'cultura';

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase().database;
    return await db.query(_table, orderBy: 'nome ASC');
  }


}