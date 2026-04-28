class Local {
  final int? id;
  final int propriedadeId;
  final String nome;
  final double areaM2;
  final String tipo;
  final bool temQuebraVento;
  final bool temAreaSensivel;
  final String? observacoes;

  Local({
    this.id,
    required this.propriedadeId,
    required this.nome,
    required this.areaM2,
    required this.tipo,
    this.temQuebraVento = false,
    this.temAreaSensivel = false,
    this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propriedadeId': propriedadeId,
      'nome': nome,
      'areaM2': areaM2,
      'tipo': tipo,
      'quebra_vento': temQuebraVento ? 1 : 0,
      'area_sensivel': temAreaSensivel ? 1 : 0,
      'observacoes': observacoes,
    };
  }

  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      id: map['id'],
      propriedadeId: map['propriedadeId'] ?? 0,
      nome: map['nome'] ?? '',
      areaM2: (map['areaM2'] as num?)?.toDouble() ?? 0.0,
      tipo: map['tipo'] ?? '',
      temQuebraVento: map['quebra_vento'] == 1,
      temAreaSensivel: map['area_sensivel'] == 1,
      observacoes: map['observacoes'],
    );
  }
}
