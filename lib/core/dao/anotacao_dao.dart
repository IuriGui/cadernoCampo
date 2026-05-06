import '../database/app_database.dart';
import '../models/anotacao.dart';

class AnotacaoDAO {
  static const String table = 'anotacao';

  Future<int> insertAnotacao(Anotacao anotacao) async {
    final db = await AppDatabase().database;
    return await db.insert(table, anotacao.toMap());
  }

  Future<List<Anotacao>> getAnotacoesByPropriedade(int propriedadeId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, a.nome as nomeAtividade, l.nome as nomeLocal, ac.nome as nomeArea,
             c.nome as nomeCultura, i.produto as nomeInsumo
      FROM $table r
      JOIN atividade a ON r.atividade_id = a.id
      JOIN area_cultivo ac ON r.area_cultivo_id = ac.id
      JOIN local l ON ac.local_id = l.id
      LEFT JOIN cultura c ON r.cultura_id = c.id
      LEFT JOIN insumo i ON r.insumo_id = i.id
      WHERE l.propriedade_id = ?
      ORDER BY r.data_criacao DESC
    ''', [propriedadeId]);
    return maps.map((e) => Anotacao.fromMap(e)).toList();
  }

  Future<List<Anotacao>> getAnotacoesByArea(int areaId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, a.nome as nomeAtividade, l.nome as nomeLocal, ac.nome as nomeArea,
             c.nome as nomeCultura, i.produto as nomeInsumo
      FROM $table r
      JOIN atividade a ON r.atividade_id = a.id
      LEFT JOIN area_cultivo ac ON r.area_cultivo_id = ac.id
      LEFT JOIN local l ON ac.local_id = l.id
      LEFT JOIN cultura c ON r.cultura_id = c.id
      LEFT JOIN insumo i ON r.insumo_id = i.id
      WHERE r.area_cultivo_id = ?
      ORDER BY r.data_criacao DESC
    ''', [areaId]);
    return maps.map((e) => Anotacao.fromMap(e)).toList();
  }
}
