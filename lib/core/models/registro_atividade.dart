class RegistroAtividade {
  final int? id;
  final DateTime dataOcorrencia;
  final int areaCultivoId;
  final int? quantidade;
  final int atividadeId;
  final int? culturaId;
  final int? destinacaoId;
  final int? tempoEstimadoMin;
  final String? observacoes;
  final int? insumoId;
  final String? unidadeInsumo;
  final int responsavelId;

  // Campos para exibição (joins)
  final String? nomeAtividade;
  final String? nomeResponsavel;
  final String? nomeLocal;
  final String? nomeArea;
  final String? nomeCultura;
  final String? nomeInsumo;
  final String? nomeDestino;

  RegistroAtividade({
    this.id,
    required this.dataOcorrencia,
    required this.areaCultivoId,
    this.quantidade,
    required this.atividadeId,
    this.culturaId,
    this.destinacaoId,
    this.tempoEstimadoMin,
    this.observacoes,
    this.insumoId,
    this.unidadeInsumo,
    required this.responsavelId,
    this.nomeAtividade,
    this.nomeResponsavel,
    this.nomeLocal,
    this.nomeArea,
    this.nomeCultura,
    this.nomeInsumo,
    this.nomeDestino,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataOcorrencia': dataOcorrencia.toIso8601String(),
      'areaCultivoId': areaCultivoId,
      'quantidade': quantidade,
      'atividadeId': atividadeId,
      'culturaId': culturaId,
      'destinacaoId': destinacaoId,
      'tempoEstimadoMin': tempoEstimadoMin,
      'observacoes': observacoes,
      'insumoId': insumoId,
      'unidadeInsumo': unidadeInsumo,
      'responsavelId': responsavelId,
    };
  }

  factory RegistroAtividade.fromMap(Map<String, dynamic> map) {
    return RegistroAtividade(
      id: map['id'],
      dataOcorrencia: map['dataOcorrencia'] != null 
          ? DateTime.parse(map['dataOcorrencia']) 
          : DateTime.now(),
      areaCultivoId: map['areaCultivoId'] ?? 0,
      quantidade: map['quantidade'],
      atividadeId: map['atividadeId'] ?? 0,
      culturaId: map['culturaId'],
      destinacaoId: map['destinacaoId'],
      tempoEstimadoMin: map['tempoEstimadoMin'],
      observacoes: map['observacoes'],
      insumoId: map['insumoId'],
      unidadeInsumo: map['unidadeInsumo'],
      responsavelId: map['responsavelId'] ?? 0,
      nomeAtividade: map['nomeAtividade'],
      nomeResponsavel: map['nomeResponsavel'],
      nomeLocal: map['nomeLocal'],
      nomeArea: map['nomeArea'],
      nomeCultura: map['nomeCultura'],
      nomeInsumo: map['nomeInsumo'],
      nomeDestino: map['nomeDestino'],
    );
  }
}
