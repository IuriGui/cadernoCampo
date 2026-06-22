import '../database/app_database.dart';
import '../models/anotacao.dart';

class AnotacaoDAO {

  static const String _baseQuery = '''
    SELECT
      r.*,
      a.nome    AS nomeAtividade,
      l.nome    AS nomeLocal,
      ac.nome   AS nomeArea,
      c.nome    AS nomeCultura,
      i.produto AS nomeInsumo,
      ce.nome   AS nomeCanal
    FROM anotacao r
    INNER JOIN atividade      a  ON a.id  = r.atividade_id
    INNER JOIN area_cultivo   ac ON ac.id = r.area_cultivo_id
    INNER JOIN local          l  ON l.id  = ac.local_id
    LEFT  JOIN cultura        c  ON c.id  = r.cultura_id
    LEFT  JOIN insumo         i  ON i.id  = r.insumo_id
    LEFT  JOIN canal_escoamento ce ON ce.id = r.canal_escoamento_id
    WHERE r.is_deleted = 0
  ''';

  Future<int> insertAnotacao(
      Anotacao anotacao, {
        bool isColheita = false,
        int? colheitaId,
        int? canalEscoamentoId,
      }) async {
    final db = await AppDatabase().database;

    if (isColheita) {
      return await db.transaction((txn) async {
        final anotacaoId = await txn.insert('anotacao', anotacao.toMap());

        await txn.insert('colheita', {
          'anotacao_id': anotacaoId,
          'unidade_medida': anotacao.unidadeMedida ?? 'kg',
          'quantidade': anotacao.quantidade,
        });

        return anotacaoId;
      });
    }

    if (colheitaId != null && canalEscoamentoId != null) {
      final map = anotacao.toMap()
        ..['colheita_id'] = colheitaId
        ..['canal_escoamento_id'] = canalEscoamentoId;
      return await db.insert('anotacao', map);
    }

    return await db.insert('anotacao', anotacao.toMap());
  }


  Future<Anotacao> getAnotacoesById(int id) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      'anotacao',
      where: 'id = ?',
      whereArgs: [id],
    );
    print(maps);
    return maps.map(Anotacao.fromMap).first;
  }

  Future<List<Map<String, dynamic>>> getColheitasByLocal(int localId) async {
    final db = await AppDatabase().database;
    return await db.rawQuery('''
    SELECT c.id, a.data_criacao, cu.nome as cultura
    FROM colheita c
    JOIN anotacao a ON a.id = c.anotacao_id
    JOIN area_cultivo ac ON ac.id = a.area_cultivo_id
    LEFT JOIN cultura cu ON cu.id = a.cultura_id
    WHERE ac.local_id = ?
  ''', [localId]);
  }

  Future<List<Map<String, dynamic>>> getAnotacoesByCanal(int canalId) async {
    final db = await AppDatabase().database;

    final maps = await db.rawQuery('''
SELECT
    a_dest.id,
    a_dest.data_criacao,
    a_dest.id,
    c.nome AS nome_cultura
FROM anotacao a_dest
JOIN colheita col
    ON col.id = a_dest.colheita_id
JOIN anotacao a_col
    ON a_col.id = col.anotacao_id
LEFT JOIN cultura c
    ON c.id = a_col.cultura_id
WHERE a_dest.canal_escoamento_id = ?
  AND a_dest.is_deleted = 0
''', [canalId]);

    print('Rows encontradas: ${maps.length}');
    for (final row in maps) {
      print(row);
    }



    print('Canal pesquisado: $canalId');
    print('Rows encontradas: ${maps.length}');



    return maps;



  }



  Future<List<Anotacao>> getAnotacoesByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    final maps = await db.rawQuery(
      '$_baseQuery AND l.propriedade_id = ? ORDER BY r.data_criacao DESC',
      [propriedadeId],
    );
    return maps.map(Anotacao.fromMap).toList();
  }

  Future<List<Anotacao>> getUltimasAnotacoes(int propriedadeId) async {
    final db = await AppDatabase().database;
    final maps = await db.rawQuery(
      '$_baseQuery AND l.propriedade_id = ? ORDER BY r.data_criacao DESC LIMIT 3',
      [propriedadeId],
    );
    return maps.map(Anotacao.fromMap).toList();
  }

  Future<List<Anotacao>> getAnotacoesDoDia(int propriedadeId) async {
    final db = await AppDatabase().database;
    final hoje = DateTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day).toIso8601String();
    final fimDia = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59).toIso8601String();

    final maps = await db.rawQuery(
      '$_baseQuery AND l.propriedade_id = ? AND r.data_criacao BETWEEN ? AND ? ORDER BY r.data_criacao DESC',
      [propriedadeId, inicioDia, fimDia],
    );
    return maps.map(Anotacao.fromMap).toList();
  }

  Future<List<Anotacao>> getAnotacoesByArea(int areaId) async {
    final db = await AppDatabase().database;
    final maps = await db.rawQuery(
      '$_baseQuery AND r.area_cultivo_id = ? ORDER BY r.data_criacao DESC',
      [areaId],
    );
    return maps.map(Anotacao.fromMap).toList();
  }

  Future<int> softDeleteAnotacao(int id) async {
    final db = await AppDatabase().database;
    return await db.transaction((txn) async {
      await txn.update(
        'colheita',
        {'is_deleted': 1},
        where: 'anotacao_id = ?',
        whereArgs: [id],
      );

      return await txn.update(
        'anotacao',
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
}