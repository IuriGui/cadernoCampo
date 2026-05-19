class ClimaInfo {
  final double tempMin;
  final double tempMax;
  final double precipitacaoProbabilidade;
  final double precipitacao;
  final double umidade;
  final double velocidadeVento;
  final String direcaoVento;

  ClimaInfo({
    required this.tempMin,
    required this.tempMax,
    required this.precipitacaoProbabilidade,
    required this.precipitacao,
    required this.umidade,
    required this.velocidadeVento,
    required this.direcaoVento,
  });

  static String _grausParaDirecao(double graus) {
    const direcoes = ['N', 'NE', 'L', 'SE', 'S', 'SO', 'O', 'NO'];
    final index = ((graus + 22.5) / 45).floor() % 8;
    return direcoes[index];
  }

  factory ClimaInfo.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;

    final tempMax = (daily['temperature_2m_max'] as List).first as double;
    final tempMin = (daily['temperature_2m_min'] as List).first as double;
    final precipitacao = (daily['precipitation_sum'] as List).first as double;
    final precipProb =
    ((daily['precipitation_probability_max'] as List).first as num)
        .toDouble();
    final vento =
    ((daily['windspeed_10m_max'] as List).first as num).toDouble();
    final direcaoGraus =
    ((daily['winddirection_10m_dominant'] as List).first as num).toDouble();

    final umidades = (hourly['relativehumidity_2m'] as List)
        .take(8)
        .map((e) => (e as num).toDouble());
    final umidadeMedia =
        umidades.reduce((a, b) => a + b) / umidades.length;

    return ClimaInfo(
      tempMin: tempMin,
      tempMax: tempMax,
      precipitacaoProbabilidade: precipProb,
      precipitacao: precipitacao,
      umidade: umidadeMedia,
      velocidadeVento: vento,
      direcaoVento: _grausParaDirecao(direcaoGraus),
    );
  }
}