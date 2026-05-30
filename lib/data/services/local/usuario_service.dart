import '../../database/app_database.dart';

class UsuarioService {
  static const String _table = 'usuario';

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    return await db.insert(_table, data);
  }

  Future<Map<String, dynamic>?> getByEmailAndPassword(String email, String password) async {
    final db = await AppDatabase().database;
    final rows = await db.query(
      _table,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<Map<String, dynamic>?> getById(int id) async {
    final db = await AppDatabase().database;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty ? rows.first : null;
  }

}