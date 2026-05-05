class Cultura {
  final int? id;
  final String nome;
  final String categoria;

  Cultura({this.id, required this.nome, required this.categoria});

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'categoria': categoria,
      };

  factory Cultura.fromMap(Map<String, dynamic> map) => Cultura(
        id: map['id'],
        nome: map['nome'] ?? '',
        categoria: map['categoria'] ?? '',
      );
}
