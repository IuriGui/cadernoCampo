class ClimaInfo {
  final DateTime data;
  final double tempMin;
  final double tempMax;
  final double precipitacaoProbabilidade;
  final double precipitacao;
  final double umidade;
  final double velocidadeVento;
  final String direcaoVento;

  ClimaInfo({
    required this.data,
    required this.tempMin,
    required this.tempMax,
    required this.precipitacaoProbabilidade,
    required this.precipitacao,
    required this.umidade,
    required this.velocidadeVento,
    required this.direcaoVento,
  });

  static String _grausParaDirecao(double graus) {
    const direcoes = ['Norte', 'Nordeste', 'Leste', 'Sudeste', 'Sul', 'Sudoeste', 'Oeste', 'Noroeste'];
    final index = ((graus + 22.5) / 45).floor() % 8;
    return direcoes[index];
  }

  /// Constrói um ClimaInfo por dia presente na resposta da Open-Meteo.
  static List<ClimaInfo> fromJsonList(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;

    final datas = (daily['time'] as List).cast<String>();
    final tempsMax = daily['temperature_2m_max'] as List;
    final tempsMin = daily['temperature_2m_min'] as List;
    final precipitacoes = daily['precipitation_sum'] as List;
    final precipProbs = daily['precipitation_probability_max'] as List;
    final ventos = daily['windspeed_10m_max'] as List;
    final direcoes = daily['winddirection_10m_dominant'] as List;
    final umidadesHorarias = hourly['relativehumidity_2m'] as List;

    return List.generate(datas.length, (i) {
      // primeiras 8h do dia correspondente, pra estimar a umidade média do dia
      final inicioHora = (i * 24).clamp(0, umidadesHorarias.length);
      final fimHora = (i * 24 + 8).clamp(0, umidadesHorarias.length);
      final umidadesDoDia = umidadesHorarias
          .sublist(inicioHora, fimHora)
          .map((e) => (e as num).toDouble())
          .toList();
      final umidadeMedia = umidadesDoDia.isEmpty
          ? 0.0
          : umidadesDoDia.reduce((a, b) => a + b) / umidadesDoDia.length;

      return ClimaInfo(
        data: DateTime.parse(datas[i]),
        tempMin: (tempsMin[i] as num).toDouble(),
        tempMax: (tempsMax[i] as num).toDouble(),
        precipitacaoProbabilidade: (precipProbs[i] as num).toDouble(),
        precipitacao: (precipitacoes[i] as num).toDouble(),
        umidade: umidadeMedia,
        velocidadeVento: (ventos[i] as num).toDouble(),
        direcaoVento: _grausParaDirecao((direcoes[i] as num).toDouble()),
      );
    });
  }

  /// Mantido por compatibilidade: extrai só o primeiro dia.
  factory ClimaInfo.fromJson(Map<String, dynamic> json) => fromJsonList(json).first;
}