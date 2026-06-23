class EventoRastreabilidade {
  final int id;
  final DateTime data;
  final String nomeAtividade;
  final double? quantidade;
  final String? unidadeMedida;
  final String? observacao;
  final String? nomeInsumo;
  final String? fornecedorInsumo;
  final String? nomeCanal;
  final String? tipoCanal;

  EventoRastreabilidade({
    required this.id,
    required this.data,
    required this.nomeAtividade,
    this.quantidade,
    this.unidadeMedida,
    this.observacao,
    this.nomeInsumo,
    this.fornecedorInsumo,
    this.nomeCanal,
    this.tipoCanal,
  });

  factory EventoRastreabilidade.fromMap(Map<String, dynamic> map) {
    return EventoRastreabilidade(
      id: map['id'] as int,
      data: DateTime.parse(map['data_criacao'] as String),
      nomeAtividade: map['nomeAtividade'] as String,
      quantidade: (map['quantidade'] as num?)?.toDouble(),
      unidadeMedida: map['unidade_medida'] as String?,
      observacao: map['observacao'] as String?,
      nomeInsumo: map['nomeInsumo'] as String?,
      fornecedorInsumo: map['fornecedorInsumo'] as String?,
      nomeCanal: map['nomeCanal'] as String?,
      tipoCanal: map['tipoCanal'] as String?,
    );
  }

  /// Linha de resumo, ex: "20 kg adubo (Fornecedor X)" ou "20 cestas → Mercado Local"
  String get descricaoResumida {
    if (nomeInsumo != null) {
      final qtd = quantidade != null ? '$quantidade ${unidadeMedida ?? ''}' : '';
      return '$qtd de $nomeInsumo${fornecedorInsumo != null ? ' ($fornecedorInsumo)' : ''}';
    }
    if (nomeCanal != null) {
      final qtd = quantidade != null ? '$quantidade ${unidadeMedida ?? ''}' : '';
      return '$qtd destinado a $nomeCanal';
    }
    if (quantidade != null) {
      return '$quantidade ${unidadeMedida ?? ''}';
    }
    return observacao ?? '';
  }
}

class RelatorioRastreabilidade {
  final int plantioId;
  final DateTime dataPlantio;
  final double quantidadePlantada;
  final String? unidadeMedida;
  final String? nomeCultura;
  final String nomeArea;
  final String nomeLocal;
  final bool foiColhido;
  final List<EventoRastreabilidade> eventos;

  RelatorioRastreabilidade({
    required this.plantioId,
    required this.dataPlantio,
    required this.quantidadePlantada,
    this.unidadeMedida,
    this.nomeCultura,
    required this.nomeArea,
    required this.nomeLocal,
    required this.foiColhido,
    required this.eventos,
  });

  factory RelatorioRastreabilidade.fromQueryResult(Map<String, dynamic> result) {
    final plantio = result['plantio'] as Map<String, dynamic>;
    final eventosMaps = (result['eventos'] as List).cast<Map<String, dynamic>>();

    return RelatorioRastreabilidade(
      plantioId: plantio['id'] as int,
      dataPlantio: DateTime.parse(plantio['data_criacao'] as String),
      quantidadePlantada: (plantio['quantidade'] as num).toDouble(),
      unidadeMedida: plantio['unidade_medida'] as String?,
      nomeCultura: plantio['nomeCultura'] as String?,
      nomeArea: plantio['nomeArea'] as String,
      nomeLocal: plantio['nomeLocal'] as String,
      foiColhido: result['foiColhido'] as bool,
      eventos: eventosMaps.map(EventoRastreabilidade.fromMap).toList(),
    );
  }
}