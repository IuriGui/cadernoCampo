import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '/constants/estados.dart';
import '../services/localizacao_service.dart';
import '../../data/models/clima_info.dart';

class ClimaProvider extends ChangeNotifier {
  final Map<DateTime, ClimaInfo> _climaPorDia = {};
  String _cidadeEstado = '';
  bool _isLoading = true;
  DateTime _diaSelecionado = _normalizar(DateTime.now());

  String get cidadeEstado => _cidadeEstado;
  bool get isLoading => _isLoading;
  DateTime get diaSelecionado => _diaSelecionado;

  /// Clima do dia atualmente selecionado (compatível com o getter antigo)
  ClimaInfo? get clima => _climaPorDia[_diaSelecionado];

  ClimaInfo? climaDoDia(DateTime dia) => _climaPorDia[_normalizar(dia)];

  static DateTime _normalizar(DateTime d) => DateTime(d.year, d.month, d.day);

  void selecionarDia(DateTime dia) {
    _diaSelecionado = _normalizar(dia);
    notifyListeners();
  }

  Future<void> carregarClima() async {
    _isLoading = true;
    notifyListeners();
    try {
      final posicao = await LocalizacaoService.determinarPosicao();

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          posicao.latitude,
          posicao.longitude,
        );
        if (placemarks.isNotEmpty) {
          final Placemark lugar = placemarks.first;
          final cidade = lugar.subAdministrativeArea ?? lugar.locality ?? "Cidade não encontrada";
          String estadoBruto = (lugar.administrativeArea ?? "").trim().toUpperCase();
          final estadoSigla = brazilStates[estadoBruto.toLowerCase()] ?? estadoBruto;
          _cidadeEstado = "$cidade, $estadoSigla";
        }
      } catch (e) {
        _cidadeEstado = "Localização atual";
      }

      final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': posicao.latitude.toString(),
        'longitude': posicao.longitude.toString(),
        'daily': [
          'temperature_2m_max',
          'temperature_2m_min',
          'precipitation_sum',
          'precipitation_probability_max',
          'windspeed_10m_max',
          'winddirection_10m_dominant',
        ].join(','),
        'hourly': 'relativehumidity_2m',
        'timezone': 'America/Sao_Paulo',
        'past_days': '6',     // hoje - 6 dias
        'forecast_days': '1', // só hoje, sem previsão futura
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final lista = ClimaInfo.fromJsonList(json);
        _climaPorDia.clear();
        for (final c in lista) {
          _climaPorDia[_normalizar(c.data)] = c;
        }
      }
    } catch (_) {
      _climaPorDia.clear();
    }
    _isLoading = false;
    notifyListeners();
  }
}