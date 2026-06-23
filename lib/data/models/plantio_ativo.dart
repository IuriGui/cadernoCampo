class PlantioAtivo {
  final int id;
  final DateTime dataPlantio;
  final double quantidade;
  final String? unidadeMedida;
  final String? observacao;
  final String? nomeCultura;
  final String? categoriaCultura;
  final int areaCultivoId;
  final String nomeArea;
  final String nomeLocal;
  final int diasDesdePlantio;

  PlantioAtivo({
    required this.id,
    required this.dataPlantio,
    required this.quantidade,
    this.unidadeMedida,
    this.observacao,
    this.nomeCultura,
    this.categoriaCultura,
    required this.areaCultivoId,
    required this.nomeArea,
    required this.nomeLocal,
    required this.diasDesdePlantio,
  });

  factory PlantioAtivo.fromMap(Map<String, dynamic> map) {
    return PlantioAtivo(
      id: map['id'] as int,
      dataPlantio: DateTime.parse(map['dataPlantio'] as String),
      quantidade: (map['quantidade'] as num).toDouble(),
      unidadeMedida: map['unidade_medida'] as String?,
      observacao: map['observacao'] as String?,
      nomeCultura: map['nomeCultura'] as String?,
      categoriaCultura: map['categoriaCultura'] as String?,
      areaCultivoId: map['areaCultivoId'] as int,
      nomeArea: map['nomeArea'] as String,
      nomeLocal: map['nomeLocal'] as String,
      diasDesdePlantio: map['diasDesdePlantio'] as int,
    );
  }

  String get tempoDecorrido {
    if (diasDesdePlantio <= 0) return 'Plantado hoje';
    if (diasDesdePlantio == 1) return 'Há 1 dia';
    return 'Há $diasDesdePlantio dias';
  }
}