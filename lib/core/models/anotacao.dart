class Anotacao {
  final int? id;
  final int? areaCultivoId;
  final DateTime dataCriacao;
  final String? unidadeMedida;
  final double quantidade;
  final int atividadeId;
  final int? insumoId;
  final int? culturaId;

  final String? nomeAtividade;
  final String? nomeLocal;
  final String? nomeArea;
  final String? nomeCultura;
  final String? nomeInsumo;
  final String? nomeDestino;
  final String? observacao;

  Anotacao({
    this.id,
    this.areaCultivoId,
    required this.dataCriacao,
    this.unidadeMedida,
    required this.quantidade,
    required this.atividadeId,
    this.insumoId,
    this.culturaId,
    this.nomeAtividade,
    this.nomeLocal,
    this.nomeArea,
    this.nomeCultura,
    this.nomeInsumo,
    this.nomeDestino,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'area_cultivo_id': areaCultivoId,
      'data_criacao': dataCriacao.toIso8601String(),
      'unidade_medida': unidadeMedida,
      'quantidade': quantidade,
      'atividade_id': atividadeId,
      'insumo_id': insumoId,
      'cultura_id': culturaId,
      'observacao': observacao,
    };
  }

  factory Anotacao.fromMap(Map<String, dynamic> map) {
    return Anotacao(
      id: map['id'],
      areaCultivoId: map['area_cultivo_id'],
      dataCriacao: DateTime.parse(map['data_criacao'] ?? DateTime.now().toIso8601String()),
      unidadeMedida: map['unidade_medida'],
      quantidade: (map['quantidade'] as num?)?.toDouble() ?? 0.0,
      atividadeId: map['atividade_id'] ?? 0,
      insumoId: map['insumo_id'],
      culturaId: map['cultura_id'],
      nomeAtividade: map['nomeAtividade'],
      nomeLocal: map['nomeLocal'],
      nomeArea: map['nomeArea'],
      nomeCultura: map['nomeCultura'],
      nomeInsumo: map['nomeInsumo'],
      nomeDestino: map['nomeDestino'],
      observacao: map['observacao']
    );
  }
}
