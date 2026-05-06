class Insumo {
  final int? id;
  final String produto;
  final String fornecedor;
  final DateTime dataAquisicao;
  final int? propriedadeId;

  Insumo({
    this.id,
    required this.produto,
    required this.fornecedor,
    required this.dataAquisicao,
    this.propriedadeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto': produto,
      'fornecedor': fornecedor,
      'data_aquisicao': dataAquisicao.toIso8601String(),
      'propriedade_id': propriedadeId,
    };
  }

  factory Insumo.fromMap(Map<String, dynamic> map) {
    return Insumo(
      id: map['id'],
      produto: map['produto'] ?? '',
      fornecedor: map['fornecedor'] ?? '',
      dataAquisicao: DateTime.parse(map['data_aquisicao'] ?? DateTime.now().toIso8601String()),
      propriedadeId: map['propriedade_id'],
    );
  }
}
