import '../../domain/models/local/local.dart';
import '../../domain/models/propriedade/propriedade.dart';
import '../services/local/local_service.dart';
import '../services/local/propriedade_service.dart';

class LocalRepository {
  final LocalService _service;
  final PropriedadeService _propriedadeService;

  LocalRepository(this._service, this._propriedadeService);

  Future<List<Local>> getByPropriedade(int propriedadeId) async {
    final rows = await _service.getByPropriedade(propriedadeId);
    return Future.wait(rows.map(_toModel));
  }

  Future<List<Local>> getTopThree(int propriedadeId) async {
    final rows = await _service.getTopThree(propriedadeId);
    return Future.wait(rows.map(_toModel));
  }

  Future<void> criar(Local local) async {
    await _service.insert(_toMap(local));
  }

  Future<void> atualizar(Local local) async {
    await _service.update(_toMap(local));
  }

  Future<void> deletar(int id) async {
    await _service.softDelete(id);
  }

  Future<Local> _toModel(Map<String, dynamic> map) async {
    final propRow = await _propriedadeService.getById(map['propriedade_id']);
    return Local(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      areaEmMetros: (map['area_em_metros'] as num).toDouble(),
      quebraVento: map['quebra_vento'] == 1,
      areaSensivel: map['area_sensivel'] == 1,
      observacoes: map['observacoes'],
      propriedade: Propriedade(
        id: propRow!['id'],
        nome: propRow['nome'],
        cidade: propRow['cidade'],
        estado: propRow['estado'],
        cep: propRow['cep'],
        areaTotal: (propRow['area_total'] as num).toDouble(),
      ),
    );
  }

  Map<String, dynamic> _toMap(Local l) => {
    'id': l.id,
    'nome': l.nome,
    'tipo': l.tipo,
    'area_em_metros': l.areaEmMetros,
    'quebra_vento': l.quebraVento ? 1 : 0,
    'area_sensivel': l.areaSensivel ? 1 : 0,
    'observacoes': l.observacoes,
    'propriedade_id': l.propriedade.id,
    'is_deleted': 0,
  };
}