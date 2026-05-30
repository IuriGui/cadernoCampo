import '../../database/app_database.dart';

class AnotacaoService {
  static const String _baseQuery = '''
  SELECT
    r.*,
    a.nome     AS nomeAtividade,
    l.nome     AS nomeLocal,
    ac.nome    AS nomeArea,
    c.nome     AS nomeCultura,
    i.produto  AS nomeInsumo,
    d.nome     AS nomeDestino
  FROM anotacao r
  INNER JOIN atividade    a  ON a.id  = r.atividade_id
  INNER JOIN area_cultivo ac ON ac.id = r.area_cultivo_id
  INNER JOIN local        l  ON l.id  = ac.local_id
  LEFT  JOIN cultura      c  ON c.id  = r.cultura_id
  LEFT  JOIN insumo       i  ON i.id  = r.insumo_id
  LEFT  JOIN colheita     cl ON cl.anotacao_id = r.id
  WHERE r.is_deleted = 0
''';
  static const String _table = 'anotacao';

  Future<int> insert(Map<String, dynamic> data, {String? unidadeMedida, double? quantidade}) async {
    final db = await AppDatabase().database;


    return await db.transaction((txn) async {
      final anotacaoId = await txn.insert('anotacao', data);
      await txn.insert('colheita', {
        'anotacao_id': anotacaoId,
        'unidade_medida': unidadeMedida ?? 'kg',
        'quantidade': quantidade,
      });
      return anotacaoId;
    });
  }

  Future<List<Map<String, dynamic>>> getByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    return await db.rawQuery(
      '$_baseQuery AND l.propriedade_id = ? ORDER BY r.data_criacao DESC',
      [propriedadeId],
    );
  }

  Future<List<Map<String, dynamic>>> getUltimas(int propriedadeId) async {
    final db = await AppDatabase().database;
    return await db.rawQuery(
      '$_baseQuery AND l.propriedade_id = ? ORDER BY r.data_criacao DESC LIMIT 3',
      [propriedadeId],
    );
  }

  Future<List<Map<String, dynamic>>> getDoDia(int propriedadeId) async {
    final db = await AppDatabase().database;
    final hoje = DateTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day).toIso8601String();
    final fimDia = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59).toIso8601String();
    return await db.rawQuery(
      '$_baseQuery AND l.propriedade_id = ? AND r.data_criacao BETWEEN ? AND ? ORDER BY r.data_criacao DESC',
      [propriedadeId, inicioDia, fimDia],
    );
  }

  Future<List<Map<String, dynamic>>> getByArea(int areaId) async {
    final db = await AppDatabase().database;
    return await db.rawQuery(
      '$_baseQuery AND r.area_cultivo_id = ? ORDER BY r.data_criacao DESC',
      [areaId],
    );
  }

  Future<void> softDelete(int id) async {
    final db = await AppDatabase().database;
    await db.transaction((txn) async {
      await txn.update('colheita', {'is_deleted': 1},
          where: 'anotacao_id = ?', whereArgs: [id]);
      await txn.update('anotacao', {'is_deleted': 1},
          where: 'id = ?', whereArgs: [id]);
    });
  }


}
