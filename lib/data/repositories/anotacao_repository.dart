import '../../domain/models/anotacao/anotacao.dart';
import '../../domain/models/areaCultivo/area_cultivo.dart';
import '../../domain/models/atividade/atividade.dart';
import '../../domain/models/cultura/cultura.dart';
import '../../domain/models/insumo/insumo.dart';
import '../../domain/models/propriedade/propriedade.dart';
import '../services/local/anotacao_service.dart';

class AnotacaoRepository {
  final AnotacaoService _service;

  AnotacaoRepository(this._service);

  Future<List<Anotacao>> getByPropriedade(int propriedadeId) async {
    final rows = await _service.getByPropriedade(propriedadeId);
    return rows.map(_toModel).toList();
  }

  Future<List<Anotacao>> getUltimas(int propriedadeId) async {
    final rows = await _service.getUltimas(propriedadeId);
    return rows.map(_toModel).toList();
  }

  Future<List<Anotacao>> getDoDia(int propriedadeId) async {
    final rows = await _service.getDoDia(propriedadeId);
    return rows.map(_toModel).toList();
  }

  Future<List<Anotacao>> getByArea(int areaId) async {
    final rows = await _service.getByArea(areaId);
    return rows.map(_toModel).toList();
  }

  Future<void> criar(Anotacao anotacao,) async {
    await _service.insert(
      _toMap(anotacao),
      unidadeMedida: anotacao.unidadeMedida,
      quantidade: anotacao.quantidade,
    );
  }

  Future<void> deletar(int id) async {
    await _service.softDelete(id);
  }

  Anotacao _toModel(Map<String, dynamic> map) => Anotacao(
    id: map['id'],
    dataCriacao: DateTime.parse(map['data_criacao']),
    quantidade: (map['quantidade'] as num).toDouble(),
    unidadeMedida: map['unidade_medida'],
    observacao: map['observacao'],
    atividade: Atividade(
      id: map['atividade_id'],
      nome: map['nomeAtividade'] ?? '',
      descricao: '',
      tipo: '',
    ),
    areaCultivo: map['area_cultivo_id'] != null
        ? AreaCultivo(
      id: map['area_cultivo_id'],
      nome: map['nomeArea'] ?? '',
      propriedade: Propriedade(
        id: 0,
        nome: map['nomeLocal'] ?? '',
        cidade: '',
        estado: '',
        cep: '',
        areaTotal: 0,
      ),
    )
        : null,
    insumo: map['insumo_id'] != null
        ? Insumo(
      id: map['insumo_id'],
      nome: map['nomeInsumo'] ?? '',
      unidadeMedida: '',
      propriedade: Propriedade(
        id: 0,
        nome: '',
        cidade: '',
        estado: '',
        cep: '',
        areaTotal: 0,
      ),
    )
        : null,
    cultura: map['cultura_id'] != null
        ? Cultura(
      id: map['cultura_id'],
      nome: map['nomeCultura'] ?? '',
      descricao: '',
    )
        : null,
  );

  Map<String, dynamic> _toMap(Anotacao a) => {
    'data_criacao': a.dataCriacao.toIso8601String(),
    'quantidade': a.quantidade,
    'unidade_medida': a.unidadeMedida,
    'observacao': a.observacao,
    'atividade_id': a.atividade.id,
    'area_cultivo_id': a.areaCultivo?.id,
    'insumo_id': a.insumo?.id,
    'cultura_id': a.cultura?.id,
    'is_deleted': 0,
  };
}