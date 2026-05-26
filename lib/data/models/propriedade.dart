class Propriedade {
  final int? id;
  final String nome;
  final String? observacao;
  final String cep;
  final String cidade;
  final String estado;
  final double areaTotal;
  final double areaPropria;
  final double? areaArrendada;
  final double? areaProducaoVegetal;
  final bool isDeleted;

  Propriedade({
    this.id,
    required this.nome,
    this.observacao,
    required this.cep,
    required this.cidade,
    required this.estado,
    required this.areaTotal,
    required this.areaPropria,
    this.areaArrendada,
    this.areaProducaoVegetal,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'observacao': observacao,
      'cep': cep,
      'cidade': cidade,
      'estado': estado,
      'area_total': areaTotal,
      'area_propria': areaPropria,
      'area_arrendada': areaArrendada,
      'area_producao_vegetal': areaProducaoVegetal,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory Propriedade.fromMap(Map<String, dynamic> map) {
    return Propriedade(
      id: map['id'],
      nome: map['nome'] ?? '',
      observacao: map['observacao'],
      cep: map['cep'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      areaTotal: (map['area_total'] as num?)?.toDouble() ?? 0.0,
      areaPropria: (map['area_propria'] as num?)?.toDouble() ?? 0.0,
      areaArrendada: (map['area_arrendada'] as num?)?.toDouble(),
      areaProducaoVegetal: (map['area_producao_vegetal'] as num?)?.toDouble(),
      isDeleted: map['is_deleted'] == 1,
    );
  }
}
