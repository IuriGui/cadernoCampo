class Destino {
  final int? id;
  final String nome;

  Destino({this.id, required this.nome});

  Map<String, dynamic> toMap() => {'id': id, 'nome': nome};

  factory Destino.fromMap(Map<String, dynamic> map) =>
      Destino(id: map['id'], nome: map['nome'] ?? '');
}
