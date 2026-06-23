import '../database/app_database.dart';
import '../models/evento_rastreabilidade.dart';

class RastreabilidadeDao {
  Future<Map<String, dynamic>> _buscarDadosRastreabilidade(int plantioId) async {
    final db = await AppDatabase().database;

    // 1. Dados base do plantio
    final plantioMaps = await db.rawQuery('''
    SELECT
      a.id, a.data_criacao, a.quantidade, a.unidade_medida, a.observacao,
      a.area_cultivo_id,
      c.nome            AS nomeCultura,
      ac.nome           AS nomeArea,
      l.nome            AS nomeLocal,
      l.propriedade_id
    FROM anotacao a
    JOIN area_cultivo ac ON ac.id = a.area_cultivo_id
    JOIN local l ON l.id = ac.local_id
    LEFT JOIN cultura c ON c.id = a.cultura_id
    WHERE a.id = ? AND a.is_deleted = 0
  ''', [plantioId]);

    if (plantioMaps.isEmpty) {
      throw Exception('Plantio $plantioId não encontrado');
    }
    final plantio = plantioMaps.first;
    final areaCultivoId = plantio['area_cultivo_id'] as int;
    final dataPlantio = plantio['data_criacao'] as String;

    // 2. Verifica se já existe evento de colheita pra esse plantio (limita o período da linha do tempo)
    final colheitaEventoMaps = await db.rawQuery('''
    SELECT data_criacao FROM anotacao
    WHERE plantio_id = ? AND is_deleted = 0
    LIMIT 1
  ''', [plantioId]);

    final dataLimite = colheitaEventoMaps.isNotEmpty
        ? colheitaEventoMaps.first['data_criacao'] as String
        : DateTime.now().toIso8601String();

    // 3. Id da colheita na tabela 'colheita' (pra rastrear destinações)
    final colheitaIdMaps = await db.rawQuery('''
    SELECT id FROM colheita WHERE anotacao_id = ? AND is_deleted = 0 LIMIT 1
  ''', [plantioId]);
    final colheitaTabelaId = colheitaIdMaps.isNotEmpty
        ? colheitaIdMaps.first['id'] as int
        : -1; // placeholder que não casa com nenhum id real

    // 4. Linha do tempo completa do plantio
    final eventos = await db.rawQuery('''
    SELECT
      a.id,
      a.data_criacao,
      at.nome           AS nomeAtividade,
      a.quantidade,
      a.unidade_medida,
      a.observacao,
      i.produto         AS nomeInsumo,
      i.fornecedor      AS fornecedorInsumo,
      ce.nome           AS nomeCanal,
      ce.tipo           AS tipoCanal
    FROM anotacao a
    JOIN atividade at ON at.id = a.atividade_id
    LEFT JOIN insumo           i  ON i.id  = a.insumo_id
    LEFT JOIN canal_escoamento ce ON ce.id = a.canal_escoamento_id
    WHERE a.is_deleted = 0
      AND (
        a.id = ?                         -- o próprio evento de plantio
        OR a.plantio_id = ?              -- o evento de colheita vinculado
        OR a.colheita_id = ?             -- destinações da colheita
        OR (
          a.area_cultivo_id = ?
          AND a.data_criacao BETWEEN ? AND ?
          AND a.id != ?
          AND at.nome NOT IN ('Plantio', 'Colheita', 'Destinar colheita')
        )
      )
    ORDER BY a.data_criacao ASC
  ''', [
      plantioId,
      plantioId,
      colheitaTabelaId,
      areaCultivoId,
      dataPlantio,
      dataLimite,
      plantioId,
    ]);

    return {
      'plantio': plantio,
      'eventos': eventos,
      'foiColhido': colheitaEventoMaps.isNotEmpty,
    };
  }

  Future<RelatorioRastreabilidade> getRelatorioRastreabilidade(int plantioId) async {
    final resultado = await _buscarDadosRastreabilidade(plantioId); // o método rawQuery que já montamos
    return RelatorioRastreabilidade.fromQueryResult(resultado);
  }

}