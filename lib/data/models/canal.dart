class CanalEscoamento {
  final int? id;
  final int produtorId;
  final String tipo;
  final String nome;
  final bool isDeleted;

  CanalEscoamento({
    this.id,
    required this.produtorId,
    required this.tipo,
    required this.nome,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produtor_id': produtorId,
      'tipo': tipo,
      'nome': nome,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory CanalEscoamento.fromMap(Map<String, dynamic> map) {
    return CanalEscoamento(
      id: map['id'],
      produtorId: map['produtor_id'] ?? 0,
      tipo: map['tipo'] ?? '',
      nome: map['nome'] ?? '',
      isDeleted: map['is_deleted'] == 1,
    );
  }

  CanalEscoamento copyWith({
    int? id,
    int? produtorId,
    String? tipo,
    String? nome,
    bool? isDeleted,
  }) {
    return CanalEscoamento(
      id: id ?? this.id,
      produtorId: produtorId ?? this.produtorId,
      tipo: tipo ?? this.tipo,
      nome: nome ?? this.nome,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
