class ProgramaComercializacao {
  final int? id;
  final int produtorId;
  final String tipo;
  final String valor;

  ProgramaComercializacao({
    this.id,
    required this.produtorId,
    required this.tipo,
    required this.valor,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'produtor_id': produtorId,
        'tipo': tipo,
        'valor': valor,
      };

  factory ProgramaComercializacao.fromMap(Map<String, dynamic> map) =>
      ProgramaComercializacao(
        id: map['id'],
        produtorId: map['produtor_id'] ?? 0,
        tipo: map['tipo'] ?? '',
        valor: map['valor'] ?? '',
      );
}
