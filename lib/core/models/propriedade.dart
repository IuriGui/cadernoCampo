class Propriedade {
  final int? id;
  final int usuarioId; // Relacionamento com o proprietário
  final String nome;
  final String municipio;
  final String cep;
  final String estado;
  final double areaTotal;
  final double? areaPropria;
  final double? areaArrendada;
  final double? areaProducaoVegetal;
  final String? observacoes;

  Propriedade({
    this.id,
    required this.usuarioId,
    required this.nome,
    required this.municipio,
    required this.cep,
    required this.estado,
    required this.areaTotal,
    this.areaPropria,
    this.areaArrendada,
    this.areaProducaoVegetal,
    this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'nome': nome,
      'municipio': municipio,
      'cep': cep,
      'estado': estado,
      'areaTotal': areaTotal,
      'areaPropria': areaPropria,
      'areaArrendada': areaArrendada,
      'areaProducaoVegetal': areaProducaoVegetal,
      'observacoes': observacoes,
    };
  }

  factory Propriedade.fromMap(Map<String, dynamic> map) {
    return Propriedade(
      id: map['id'],
      usuarioId: map['usuarioId'],
      nome: map['nome'],
      municipio: map['municipio'],
      cep: map['cep'],
      estado: map['estado'],
      areaTotal: map['areaTotal'],
      areaPropria: map['areaPropria'],
      areaArrendada: map['areaArrendada'],
      areaProducaoVegetal: map['areaProducaoVegetal'],
      observacoes: map['observacoes'],
    );
  }
}
