import '../database/app_database.dart';
import '../models/anotacao.dart';
import '../models/plantio_ativo.dart';

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
        int? plantioId,
        int? canalEscoamentoId,
      }) async {
    final db = await AppDatabase().database;

    if (isColheita) {
      return await db.transaction((txn) async {
        final anotacaoId = await txn.insert('anotacao', anotacao.toMap()
          ..['plantio_id'] = plantioId);

        await txn.insert('colheita', {
          'anotacao_id': plantioId,
          'unidade_medida': anotacao.unidadeMedida ?? 'uk',
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


  Future<List<PlantioAtivo>> getPlantiosAtivos(int propriedadeId) async {
    final db = await AppDatabase().database;

    final maps =  await db.rawQuery('''
    SELECT
      a.id,
      a.data_criacao    AS dataPlantio,
      a.quantidade,
      a.unidade_medida,
      a.observacao,
      c.nome            AS nomeCultura,
      c.categoria       AS categoriaCultura,
      ac.id             AS areaCultivoId,
      ac.nome           AS nomeArea,
      l.nome            AS nomeLocal,
      CAST(julianday('now') - julianday(a.data_criacao) AS INTEGER) AS diasDesdePlantio
    FROM anotacao a
    INNER JOIN area_cultivo ac ON ac.id = a.area_cultivo_id
    INNER JOIN local        l  ON l.id  = ac.local_id
    LEFT  JOIN cultura      c  ON c.id  = a.cultura_id
    WHERE a.is_deleted = 0
      AND l.propriedade_id = ?
      AND a.atividade_id = (SELECT id FROM atividade WHERE nome = 'Plantio' LIMIT 1)
      AND NOT EXISTS (
        SELECT 1 FROM colheita col
        WHERE col.anotacao_id = a.id
          AND col.is_deleted = 0
      )
    ORDER BY a.data_criacao DESC
  ''', [propriedadeId]);


    return maps.map((m) => PlantioAtivo.fromMap(Map<String, dynamic>.from(m))).toList();

  }

  Future<List<Anotacao>> getPlantiosNaoColhidosByArea(int id) async {
    final db = await AppDatabase().database;

    final maps = await db.rawQuery('''
      SELECT 
        a.*,
        cu.nome AS nomeCultura
      FROM anotacao a
      LEFT JOIN cultura cu ON cu.id = a.cultura_id
      WHERE a.is_deleted = 0 
        AND a.area_cultivo_id = ?
        AND a.atividade_id = (SELECT id FROM atividade WHERE nome = 'Plantio' LIMIT 1)
        AND NOT EXISTS (
          SELECT 1 FROM colheita c WHERE c.anotacao_id = a.id
  )
  ''', [id]);

    final results = maps.map((r) => Anotacao.fromMap(Map<String, dynamic>.from(r))).toList();
    for (final a in results) {
      print(a.toMap());
    }
    return results;
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

  Future<Map<String, dynamic>> getAnotacaoDetalhadaById(int id) async {
    final db = await AppDatabase().database;

    final maps = await db.rawQuery('''
    SELECT
      a.id,
      a.data_criacao,
      a.quantidade,
      a.unidade_medida,
      a.observacao,

      at.nome           AS nomeAtividade,

      ac.nome           AS nomeArea,
      l.nome            AS nomeLocal,
      l.tipo            AS tipoLocal,

      c.nome            AS nomeCultura,
      c.categoria       AS categoriaCltura,

      i.produto         AS nomeInsumo,
      i.fornecedor      AS fornecedorInsumo,

      ce.nome           AS nomeCanal,
      ce.tipo           AS tipoCanal,

      -- Plantio vinculado (via plantio_id na anotacao de Colheita)
      a_plantio.data_criacao    AS dataPlantio,
      a_plantio.quantidade      AS quantidadePlantada,
      a_plantio.unidade_medida  AS unidadePlantada,
      c_plantio.nome            AS culturaPlantio,
      
      -- Informações da colheita (quando o plantio já foi colhido)
      col.id             AS colheitaId,
      col.quantidade     AS quantidadeColhida,
      col.unidade_medida AS unidadeColhida

    FROM anotacao a
    INNER JOIN atividade        at        ON at.id   = a.atividade_id
    INNER JOIN area_cultivo     ac        ON ac.id   = a.area_cultivo_id
    INNER JOIN local            l         ON l.id    = ac.local_id
    LEFT  JOIN cultura          c         ON c.id    = a.cultura_id
    LEFT  JOIN insumo           i         ON i.id    = a.insumo_id
    LEFT  JOIN canal_escoamento ce        ON ce.id   = a.canal_escoamento_id
    LEFT  JOIN anotacao         a_plantio ON a_plantio.id = a.plantio_id
    LEFT  JOIN cultura          c_plantio ON c_plantio.id = a_plantio.cultura_id
    LEFT  JOIN colheita         col       ON col.anotacao_id = a.plantio_id
                                      AND col.is_deleted = 0

    WHERE a.id = ?
      AND a.is_deleted = 0
  ''', [id]);

    if (maps.isEmpty) throw Exception('Anotação $id não encontrada');
    return maps.first;
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