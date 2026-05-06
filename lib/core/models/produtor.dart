class Produtor {
  final int? id;
  final int usuarioId;
  final String nome;

  Produtor({
    this.id,
    required this.usuarioId,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'nome': nome,
    };
  }

  factory Produtor.fromMap(Map<String, dynamic> map) {
    return Produtor(
      id: map['id'],
      usuarioId: map['usuario_id'] ?? 0,
      nome: map['nome'] ?? '',
    );
  }
}
