import '../../database/app_database.dart';

class ProdutorService {

  static const String _table = 'produtor';

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    return await db.insert(_table, data);
  }

  Future<Map<String, dynamic>?> getByUsuario(int usuarioId) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      _table,
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<void> update(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    await db.update(_table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> softDelete(int id) async {
    final db = await AppDatabase().database;
    await db.update(_table, {'is_deleted': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertMecanismoControle(int produtorId, String tipo, String valor) async {
    final db = await AppDatabase().database;
    await db.insert('mecanismo_controle', {
      'produtor_id': produtorId,
      'tipo': tipo,
      'valor': valor,
    });


}

  Future<Map<String, dynamic>?> getMecanismoControleByProdutor(int produtorId) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      'mecanismo_controle',
      where: 'produtor_id = ?',
      whereArgs: [produtorId],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }





}