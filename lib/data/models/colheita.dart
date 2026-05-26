class Colheita {
  final int? id;
  final int anotacaoId;
  final String unidadeMedida;
  final double quantidade;
  final int destinoId;
  final bool isDeleted;

  Colheita({
    this.id,
    required this.anotacaoId,
    required this.unidadeMedida,
    required this.quantidade,
    required this.destinoId,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'anotacao_id': anotacaoId,
        'unidade_medida': unidadeMedida,
        'quantidade': quantidade,
        'destino_id': destinoId,
        'is_deleted': isDeleted ? 1 : 0,
      };

  factory Colheita.fromMap(Map<String, dynamic> map) => Colheita(
        id: map['id'],
        anotacaoId: map['anotacao_id'] ?? 0,
        unidadeMedida: map['unidade_medida'] ?? '',
        quantidade: (map['quantidade'] as num?)?.toDouble() ?? 0.0,
        destinoId: map['destino_id'] ?? 0,
        isDeleted: map['is_deleted'] == 1,
      );
}
