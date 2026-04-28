class Atividade {
  final int? id;
  final String nome;
  final String descricao;
  final String tipo;

  Atividade({
    this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'tipo': tipo,
      };

  factory Atividade.fromMap(Map<String, dynamic> map) => Atividade(
        id: map['id'],
        nome: map['nome'],
        descricao: map['descricao'],
        tipo: map['tipo'],
      );
}
