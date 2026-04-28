class Colheita {
  final int? id;
  final int registroAtividadeId;
  final String medida;
  final int quantidade;
  final int destinoId;

  Colheita({
    this.id,
    required this.registroAtividadeId,
    required this.medida,
    required this.quantidade,
    required this.destinoId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'registroAtividadeId': registroAtividadeId,
        'medida': medida,
        'quantidade': quantidade,
        'destinoId': destinoId,
      };

  factory Colheita.fromMap(Map<String, dynamic> map) => Colheita(
        id: map['id'],
        registroAtividadeId: map['registroAtividadeId'],
        medida: map['medida'],
        quantidade: map['quantidade'],
        destinoId: map['destinoId'],
      );
}
