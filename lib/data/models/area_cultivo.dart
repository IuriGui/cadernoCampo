class AreaCultivo {
  final int? id;
  final String nome;
  final int? localId;
  final bool isDeleted;

  AreaCultivo({
    this.id,
    required this.nome,
    this.localId,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'local_id': localId,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  factory AreaCultivo.fromMap(Map<String, dynamic> map) {
    return AreaCultivo(
      id: map['id'],
      nome: map['nome'] ?? '',
      localId: map['local_id'],
      isDeleted: map['is_deleted'] == 1,
    );
  }
}
