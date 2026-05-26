class Local {
  final int? id;
  final String nome;
  final String tipo;
  final double areaEmMetros;
  final bool quebraVento;
  final bool areaSensivel;
  final String? observacoes;
  final int propriedadeId;

  Local({
    this.id,
    required this.nome,
    required this.tipo,
    required this.areaEmMetros,
    required this.quebraVento,
    required this.areaSensivel,
    this.observacoes,
    required this.propriedadeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'area_em_metros': areaEmMetros,
      'quebra_vento': quebraVento ? 1 : 0,
      'area_sensivel': areaSensivel ? 1 : 0,
      'observacoes': observacoes,
      'propriedade_id': propriedadeId,
    };
  }

  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      id: map['id'],
      nome: map['nome'] ?? '',
      tipo: map['tipo'] ?? '',
      areaEmMetros: (map['area_em_metros'] as num?)?.toDouble() ?? 0.0,
      quebraVento: map['quebra_vento'] == 1,
      areaSensivel: map['area_sensivel'] == 1,
      observacoes: map['observacoes'],
      propriedadeId: map['propriedade_id'] ?? 0,
    );
  }
}
