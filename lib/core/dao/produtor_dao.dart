import '../database/app_database.dart';
import '../models/produtor.dart';

class ProdutorDAO {
  static const String table = 'produtor';

  Future<int> insertProdutor(Produtor produtor) async {
    final db = await AppDatabase().database;
    return await db.insert(table, produtor.toMap());
  }

  Future<void> linkProgramaProdutor(int produtorId, int programaId) async {
    final db = await AppDatabase().database;
    await db.insert('programa_produtor', {
      'produtor_id': produtorId,
      'programa_id': programaId,
    });
  }
}
