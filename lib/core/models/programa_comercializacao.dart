class ProgramaComercializacao {
  final int? id;
  final String nome;

  ProgramaComercializacao({this.id, required this.nome});

  Map<String, dynamic> toMap() => {'id': id, 'nome': nome};

  factory ProgramaComercializacao.fromMap(Map<String, dynamic> map) =>
      ProgramaComercializacao(id: map['id'], nome: map['nome']);
}
