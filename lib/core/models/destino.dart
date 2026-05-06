class Destino {
  final int? id;
  final String nome;

  Destino({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Destino.fromMap(Map<String, dynamic> map) {
    return Destino(
      id: map['id'],
      nome: map['nome'] ?? '',
    );
  }
}
