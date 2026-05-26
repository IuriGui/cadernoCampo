import '../database/app_database.dart';
import '../models/anotacao.dart';

class AnotacaoDAO {

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
  LEFT  JOIN destino      d  ON d.id  = cl.destino_id
  WHERE r.is_deleted = 0
''';

  Future<int> insertAnotacao(Anotacao anotacao, {int? destinoId}) async {
    final db = await AppDatabase().database;
    
    if (destinoId == null) {
      return await db.insert('anotacao', anotacao.toMap());
    }

    return await db.transaction((txn) async {
      final anotacaoId = await txn.insert('anotacao', anotacao.toMap());
      
      await txn.insert('colheita', {
        'anotacao_id': anotacaoId,
        'unidade_medida': anotacao.unidadeMedida ?? 'kg',
        'quantidade': anotacao.quantidade,
        'destino_id': destinoId,
      });

      return anotacaoId;
    });
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
      '$_baseQuery AND l.propriedade_id = ? AND r.is_deleted = 0 ORDER BY r.data_criacao DESC LIMIT 3',
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
      // Deleta a colheita vinculada se existir
      await txn.update(
        'colheita',
        {'is_deleted': 1},
        where: 'anotacao_id = ?',
        whereArgs: [id],
      );
      
      // Deleta a anotação
      return await txn.update(
        'anotacao',
        {'is_deleted': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
}
