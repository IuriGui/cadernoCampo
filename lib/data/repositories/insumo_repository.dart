import '../../domain/models/insumo/insumo.dart';
import '../../domain/models/propriedade/propriedade.dart';
import '../services/local/insumo_service.dart';

class InsumoRepository {
  final InsumoService _service;

  InsumoRepository(this._service);

  Future<List<Insumo>> getByPropriedade(int propriedadeId) async {
    final rows = await _service.getByPropriedade(propriedadeId);
    return rows.map(_toModel).toList();
  }

  Future<List<Insumo>> getAll() async {
    final rows = await _service.getAll();
    return rows.map(_toModel).toList();
  }

  Future<void> criar(Insumo insumo) async {
    await _service.insert(_toMap(insumo));
  }

  Insumo _toModel(Map<String, dynamic> map) => Insumo(
    id: map['id'],
    nome: map['produto'],
    unidadeMedida: map['unidade_medida'],
    propriedade: Propriedade(
      id: map['propriedade_id'],
      nome: map['prop_nome'],
      cidade: map['prop_cidade'],
      estado: map['prop_estado'],
      cep: map['prop_cep'],
      areaTotal: (map['prop_area_total'] as num).toDouble(),
    ),
  );
  Map<String, dynamic> _toMap(Insumo i) => {
    'id': i.id,
    'produto': i.nome,
    'unidade_medida': i.unidadeMedida,
    'propriedade_id': i.propriedade.id,
  };
}