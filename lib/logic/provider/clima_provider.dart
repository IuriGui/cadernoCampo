import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/estados.dart';
import '../../core/services/localizacao_service.dart';
import '../../data/models/clima_info.dart';

class ClimaProvider extends ChangeNotifier{
  ClimaInfo? _clima;
  String _cidadeEstado = 'Não foi possível determinar a localização';
  bool _isLoading = true;

  ClimaInfo? get clima => _clima;
  String get cidadeEstado => _cidadeEstado;
  bool get isLoading => _isLoading;

  Future<void> carregarClima() async {
    print("Carregando clima...");
    _isLoading = true;
    try {
      final posicao = await LocalizacaoService.determinarPosicao();

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            posicao.latitude,
            posicao.longitude
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
        'forecast_days': '1',
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        _clima = ClimaInfo.fromJson(json);
      }
    } catch (_) {
      _clima = null;
    }
    _isLoading = false;
    notifyListeners();
  }

}