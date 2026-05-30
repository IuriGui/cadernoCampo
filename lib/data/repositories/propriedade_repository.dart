import '../../domain/models/propriedade/propriedade.dart';
import '../services/local/propriedade_service.dart';

class PropriedadeRepository {
  final PropriedadeService _service;

  PropriedadeRepository(this._service);

  Future<List<Propriedade>> getAll() async {
    final rows = await _service.getAll();
    return rows.map(_toModel).toList();
  }

  Future<Propriedade?> getFirst() async {
    final row = await _service.getFirst();
    return row != null ? _toModel(row) : null;
  }

  Future<Propriedade?> getByUsuario(int usuarioId) async {
    final row = await _service.getByUsuario(usuarioId);
    return row != null ? _toModel(row) : null;
  }

  Future<Propriedade?> getById(int id) async {
    final row = await _service.getById(id);
    return row != null ? _toModel(row) : null;
  }

  Future<void> criar(Propriedade p, int produtorId) async {
    await _service.insertComVinculo(_toMap(p), produtorId);
  }

  Future<void> atualizar(Propriedade p) async {
    await _service.update(_toMap(p));
  }

  Future<void> deletar(int id) async {
    await _service.softDelete(id);
  }

  Propriedade _toModel(Map<String, dynamic> map) => Propriedade(
    id: map['id'],
    nome: map['nome'],
    cidade: map['cidade'],
    estado: map['estado'],
    cep: map['cep'],
    areaTotal: (map['area_total'] as num).toDouble(),
    observacao: map['observacao'],
    areaPropria: (map['area_propria'] as num?)?.toDouble(),
    areaArrendada: (map['area_arrendada'] as num?)?.toDouble(),
    areaProducaoVegetal: (map['area_producao_vegetal'] as num?)?.toDouble(),
  );

  Map<String, dynamic> _toMap(Propriedade p) => {
    'id': p.id,
    'nome': p.nome,
    'cidade': p.cidade,
    'estado': p.estado,
    'cep': p.cep,
    'area_total': p.areaTotal,
    'observacao': p.observacao,
    'area_propria': p.areaPropria,
    'area_arrendada': p.areaArrendada,
    'area_producao_vegetal': p.areaProducaoVegetal,
    'is_deleted': 0,
  };
}