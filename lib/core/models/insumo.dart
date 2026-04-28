class Insumo {
  final int? id;
  final String produto;
  final String fornecedor;
  final DateTime dataAquisicao;

  Insumo({
    this.id,
    required this.produto,
    required this.fornecedor,
    required this.dataAquisicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto': produto,
      'fornecedor': fornecedor,
      'dataAquisicao': dataAquisicao.toIso8601String(),
    };
  }

  factory Insumo.fromMap(Map<String, dynamic> map) {
    return Insumo(
      id: map['id'],
      produto: map['produto'],
      fornecedor: map['fornecedor'],
      dataAquisicao: DateTime.parse(map['dataAquisicao']),
    );
  }
}
