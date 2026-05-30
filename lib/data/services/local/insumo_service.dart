import '../../database/app_database.dart';

class InsumoService {
  static const String _table = 'insumo';

  Future<List<Map<String, dynamic>>> getByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    return await db.rawQuery('''
    SELECT i.*, 
           p.nome      AS prop_nome,
           p.cidade    AS prop_cidade,
           p.estado    AS prop_estado,
           p.cep       AS prop_cep,
           p.area_total AS prop_area_total
    FROM insumo i
    JOIN propriedade p ON p.id = i.propriedade_id
    WHERE i.propriedade_id = ?
    ORDER BY i.produto ASC
  ''', [propriedadeId]);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await AppDatabase().database;
    return await db.query(_table, orderBy: 'produto ASC');
  }

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;
    return await db.insert(_table, data);
  }
}