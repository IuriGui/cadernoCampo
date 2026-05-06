import '../database/app_database.dart';
import '../models/destino.dart';

class DestinoDAO {
  static const String table = 'destino';

  Future<int> insertDestino(Destino destino) async {
    final db = await AppDatabase().database;
    return await db.insert(table, destino.toMap());
  }

  Future<List<Destino>> getAllDestinos() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps.map((e) => Destino.fromMap(e)).toList();
  }

  Future<Destino?> getDestinoByNome(String nome) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'nome = ?',
      whereArgs: [nome],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Destino.fromMap(maps.first);
    }
    return null;
  }
}
