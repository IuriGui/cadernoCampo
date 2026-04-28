enum MecanismoControle { ocs, spg }

class Produtor {
  final int? id;
  final String nome;
  final MecanismoControle mecanismoControle;

  Produtor({
    this.id,
    required this.nome,
    required this.mecanismoControle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'mecanismo_controle': mecanismoControle.name.toUpperCase(),
    };
  }

  factory Produtor.fromMap(Map<String, dynamic> map) {
    return Produtor(
      id: map['id'],
      nome: map['nome'],
      mecanismoControle: MecanismoControle.values.byName(map['mecanismo_controle'].toString().toLowerCase()),
    );
  }
}
