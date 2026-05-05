class AreaCultivo {
  final int? id;
  final int localId;
  final String titulo;
  final DateTime dataCriacao;

  AreaCultivo({
    this.id,
    required this.localId,
    required this.titulo,
    required this.dataCriacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'local_id': localId,
      'titulo': titulo,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  factory AreaCultivo.fromMap(Map<String, dynamic> map) {
    return AreaCultivo(
      id: map['id'],
      localId: map['local_id'] ?? 0,
      titulo: map['titulo'] ?? '',
      dataCriacao: map['data_criacao'] != null 
          ? DateTime.parse(map['data_criacao']) 
          : DateTime.now(),
    );
  }
}
