import '../database/app_database.dart';
import '../models/produtor.dart';

class ProdutorDAO {
  static const String table = 'produtor';

  Future<int> insertProdutor(Produtor produtor) async {
    final db = await AppDatabase().database;
    return await db.insert(table, produtor.toMap());
  }

  Future<Produtor?> getProdutorByUsuario(int usuarioId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Produtor.fromMap(maps.first);
    }
    return null;
  }

  Future<void> insertProgramaComercializacao(int produtorId, String tipo, String valor) async {
    final db = await AppDatabase().database;
    await db.insert('programa_comercializacao', {
      'produtor_id': produtorId,
      'tipo': tipo,
      'valor': valor,
    });
  }

  Future<void> insertMecanismoControle(int produtorId, String tipo, String valor) async {
    final db = await AppDatabase().database;
    await db.insert('mecanismo_controle', {
      'produtor_id': produtorId,
      'tipo': tipo,
      'valor': valor,
    });
  }

  Future<List<Map<String, dynamic>>> getProgramasComercializacao(int produtorId) async {
    final db = await AppDatabase().database;
    return await db.query(
      'programa_comercializacao',
      where: 'produtor_id = ?',
      whereArgs: [produtorId],
    );
  }
}
