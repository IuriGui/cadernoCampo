import '../../domain/models/areaCultivo/area_cultivo.dart';
import '../../domain/models/propriedade/propriedade.dart';
import '../services/local/area_cultivo_service.dart';
import '../services/local/propriedade_service.dart';


class AreaCultivoRepository {
  final AreaCultivoService _service;
  final PropriedadeService _propriedadeService;

  AreaCultivoRepository(this._service, this._propriedadeService);

  Future<List<AreaCultivo>> getByLocal(int localId) async {
    final rows = await _service.getByLocal(localId);
    return Future.wait(rows.map(_toModel));
  }

  Future<void> criar(AreaCultivo area) async {
    await _service.insert(_toMap(area));
  }

  Future<void> atualizar(AreaCultivo area) async {
    await _service.update(_toMap(area));
  }

  Future<void> deletar(int id) async {
    await _service.softDelete(id);
  }

  Future<AreaCultivo> _toModel(Map<String, dynamic> map) async {
    return AreaCultivo(
      id: map['id'],
      nome: map['nome'],
      localId: map['localId']
    );
  }

  Map<String, dynamic> _toMap(AreaCultivo a) => {
    'id': a.id,
    'nome': a.nome,
    'local_id': a.localId,
    'is_deleted': 0,
  };
}