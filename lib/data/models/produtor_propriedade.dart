class ProdutorPropriedade {
  final int? id;
  final int propriedadeId;
  final int produtorId;
  final String papel;

  ProdutorPropriedade({
    this.id,
    required this.propriedadeId,
    required this.produtorId,
    required this.papel,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'propriedade_id': propriedadeId,
        'produtor_id': produtorId,
        'papel': papel,
      };

  factory ProdutorPropriedade.fromMap(Map<String, dynamic> map) =>
      ProdutorPropriedade(
        id: map['id'],
        propriedadeId: map['propriedade_id'] ?? 0,
        produtorId: map['produtor_id'] ?? 0,
        papel: map['papel'] ?? '',
      );
}
