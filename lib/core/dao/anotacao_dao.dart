import '../database/app_database.dart';
import '../models/anotacao.dart';

class AnotacaoDAO {
  static const String table = 'anotacao';

  Future<int> insertAnotacao(Anotacao anotacao, {int? destinoId}) async {
    final db = await AppDatabase().database;
    
    if (destinoId == null) {
      return await db.insert(table, anotacao.toMap());
    }

    return await db.transaction((txn) async {
      final anotacaoId = await txn.insert(table, anotacao.toMap());
      
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
    final maps = await db.rawQuery('''
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
    WHERE l.propriedade_id = ?
    ORDER BY r.data_criacao DESC
  ''', [propriedadeId]);

    return maps.map(Anotacao.fromMap).toList();
  }

  Future<List<Anotacao>> getAnotacoesByArea(int areaId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, a.nome as nomeAtividade, l.nome as nomeLocal, ac.nome as nomeArea,
             c.nome as nomeCultura, i.produto as nomeInsumo, d.nome as nomeDestino
      FROM $table r
      JOIN atividade a ON r.atividade_id = a.id
      LEFT JOIN area_cultivo ac ON r.area_cultivo_id = ac.id
      LEFT JOIN local l ON ac.local_id = l.id
      LEFT JOIN cultura c ON r.cultura_id = c.id
      LEFT JOIN insumo i ON r.insumo_id = i.id
      LEFT JOIN colheita cl ON r.id = cl.anotacao_id
      LEFT JOIN destino d ON cl.destino_id = d.id
      WHERE r.area_cultivo_id = ?
      ORDER BY r.data_criacao DESC
    ''', [areaId]);
    return maps.map((e) => Anotacao.fromMap(e)).toList();
  }
}
