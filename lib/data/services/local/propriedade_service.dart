import '../../../domain/models/propriedade/propriedade.dart';
import '../../database/app_database.dart';

class PropriedadeService {
  static const String _table = 'propriedade';

  Future<int> insertComVinculo(Map<String, dynamic> data, int produtorId) async {
    final db = await AppDatabase().database;
    return await db.transaction((txn) async {
      final propriedadeId = await txn.insert(_table, data);
      await txn.insert('produtor_propriedade', {
        'propriedade_id': propriedadeId,
        'produtor_id': produtorId,
        'papel': 'proprietário',
      });
      return propriedadeId;
    });
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase().database;
    return await db.query(_table, where: 'is_deleted = 0');
  }

  Future<Map<String, dynamic>?> getFirst() async {
    final db = await AppDatabase().database;
    final rows = await db.query(_table, where: 'is_deleted = 0', limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<Map<String, dynamic>?> getByUsuario(int usuarioId) async {
    final db = await AppDatabase().database;
    final rows = await db.rawQuery('''
      SELECT p.* FROM $_table p
      JOIN produtor_propriedade pp ON p.id = pp.propriedade_id
      JOIN produtor pr ON pp.produtor_id = pr.id
      WHERE pr.usuario_id = ? AND p.is_deleted = 0
      LIMIT 1
    ''', [usuarioId]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      _table,
      where: 'id = ? AND is_deleted = 0',
      whereArgs: [id],
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
}
