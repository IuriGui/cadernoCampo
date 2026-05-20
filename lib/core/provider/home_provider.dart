import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/estados.dart';
import '../dao/anotacao_dao.dart';
import '../dao/local_dao.dart';
import '../dao/produtor_dao.dart';
import '../dao/propriedade_dao.dart';
import '../models/anotacao.dart';
import '../models/clima_info.dart';
import '../models/local.dart';
import '../models/produtor.dart';
import '../models/propriedade.dart';
import '../models/user.dart';
import 'package:geocoding/geocoding.dart';
import '../services/localizacao_service.dart';

class HomeProvider extends ChangeNotifier {
  final User user;

  HomeProvider({required this.user});

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Propriedade? _propriedade;
  Propriedade? get propriedade => _propriedade;

  Produtor? _produtor;
  Produtor? get produtor => _produtor;

  List<Local> _locais = [];
  List<Local> get locais => _locais;

  List<Anotacao> _anotacoesDoDia = [];
  List<Anotacao> get anotacoesDoDia => _anotacoesDoDia;

  String _cidadeEstado = "Localização desconhecida";
  String get cidadeEstado => _cidadeEstado;
  ClimaInfo? _clima;
  ClimaInfo? get clima => _clima;

  Future<void> carregar() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      _carregarDadosLocais(),
      // _carregarClima(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => carregar();

  Future<void> _carregarDadosLocais() async {
    try {
      final results = await Future.wait([
        PropriedadeDAO().getPropriedadeByUsuario(user.id!),
        ProdutorDAO().getProdutorByUsuario(user.id!),
      ]);

      _propriedade = results[0] as Propriedade?;
      _produtor = results[1] as Produtor?;

      if (_propriedade != null) {
        final dataResults = await Future.wait([
          LocalDAO().getTopThreeLocais(_propriedade!.id!),
          AnotacaoDAO().getAnotacoesDoDia(_propriedade!.id!),
        ]);
        _locais = dataResults[0] as List<Local>;
        _anotacoesDoDia = dataResults[1] as List<Anotacao>;
      } else {
        _locais = [];
        _anotacoesDoDia = [];
      }
    } catch (_) {
      // falha silenciosa, app continua com valores nulos
    }
  }

  Future<void> _carregarClima() async {
    try {
      final posicao = await LocalizacaoService.determinarPosicao();

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            posicao.latitude,
            posicao.longitude
        );
        if (placemarks.isNotEmpty) {
          final Placemark lugar = placemarks.first;
          final cidade = lugar.subAdministrativeArea ?? lugar.locality ?? "Cidade";
          String estadoBruto = (lugar.administrativeArea ?? "").trim().toUpperCase();
          final estadoSigla = brazilStatesMap[estadoBruto.toLowerCase()] ?? estadoBruto;
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
  }
}
