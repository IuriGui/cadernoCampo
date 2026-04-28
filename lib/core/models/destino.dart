class Destino {
  final int? id;
  final String titulo;

  Destino({this.id, required this.titulo});

  Map<String, dynamic> toMap() => {'id': id, 'titulo': titulo};

  factory Destino.fromMap(Map<String, dynamic> map) =>
      Destino(id: map['id'], titulo: map['titulo']);
}
