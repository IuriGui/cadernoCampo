import '../database/app_database.dart';
import '../models/registro_atividade.dart';

class RegistroAtividadeDAO {
  static const String table = 'registros_atividades';

  Future<int> insertRegistro(RegistroAtividade registro) async {
    final db = await AppDatabase().database;
    return await db.insert(table, registro.toMap());
  }

  Future<List<RegistroAtividade>> getAllRegistros() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, a.nome as nomeAtividade, u.name as nomeResponsavel, l.nome as nomeLocal, ac.titulo as nomeArea
      FROM $table r
      JOIN atividades a ON r.atividadeId = a.id
      JOIN users u ON r.responsavelId = u.id
      JOIN areas_cultivo ac ON r.areaCultivoId = ac.id
      JOIN locais l ON ac.local_id = l.id
      ORDER BY r.dataOcorrencia DESC
    ''');
    return maps.map((e) => RegistroAtividade.fromMap(e)).toList();
  }

  Future<List<RegistroAtividade>> getAllRegistrosByUser(int usuarioId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, a.nome as nomeAtividade, u.name as nomeResponsavel, l.nome as nomeLocal, ac.titulo as nomeArea
      FROM $table r
      JOIN atividades a ON r.atividadeId = a.id
      JOIN users u ON r.responsavelId = u.id
      JOIN areas_cultivo ac ON r.areaCultivoId = ac.id
      JOIN locais l ON ac.local_id = l.id
      WHERE l.usuarioId = ?
      ORDER BY r.dataOcorrencia DESC
    ''', [usuarioId]);
    return maps.map((e) => RegistroAtividade.fromMap(e)).toList();
  }

  Future<List<RegistroAtividade>> getRegistrosByArea(int areaId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT r.*, a.nome as nomeAtividade, u.name as nomeResponsavel, l.nome as nomeLocal, ac.titulo as nomeArea
      FROM $table r
      JOIN atividades a ON r.atividadeId = a.id
      JOIN users u ON r.responsavelId = u.id
      JOIN areas_cultivo ac ON r.areaCultivoId = ac.id
      JOIN locais l ON ac.local_id = l.id
      WHERE r.areaCultivoId = ?
      ORDER BY r.dataOcorrencia DESC
    ''', [areaId]);
    return maps.map((e) => RegistroAtividade.fromMap(e)).toList();
  }
}
