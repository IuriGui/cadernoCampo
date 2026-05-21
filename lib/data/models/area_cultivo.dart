class AreaCultivo {
  final int? id;
  final String nome;
  final int? localId;

  AreaCultivo({
    this.id,
    required this.nome,
    this.localId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'local_id': localId,
    };
  }

  factory AreaCultivo.fromMap(Map<String, dynamic> map) {
    return AreaCultivo(
      id: map['id'],
      nome: map['nome'] ?? '',
      localId: map['local_id'],
    );
  }
}
