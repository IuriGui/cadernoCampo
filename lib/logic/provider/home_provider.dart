import 'package:caderno_de_campo/logic/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import '../../data/dao/propriedade_dao.dart';
import '../../data/models/anotacao.dart';
import '../../data/models/clima_info.dart';
import '../../data/models/local.dart';
import '../../data/models/produtor.dart';
import '../../data/models/propriedade.dart';
import '../../data/models/user.dart';
import '../../data/dao/anotacao_dao.dart';
import '../../data/dao/local_dao.dart';
import '../../data/dao/produtor_dao.dart';

class HomeProvider extends ChangeNotifier {
  final AuthProvider _auth;

  HomeProvider(this._auth);

  User? get user => _auth.user;


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


  bool _isLoadingClima = true;
  bool get isLoadingClima => _isLoadingClima;

  Future<void> carregar() async {
    _isLoading = true;
    notifyListeners();

    await _carregarDadosLocais();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => carregar();

  Future<void> _carregarDadosLocais() async {
    try {
      final userId = _auth.user!.id!;
      final propriedade = _auth.propriedade;

      if (propriedade != null) {
        final dataResults = await Future.wait([
          LocalDAO().getTopThreeLocais(propriedade.id!),
          AnotacaoDAO().getAnotacoesDoDia(propriedade.id!),
        ]);
        _locais = dataResults[0] as List<Local>;
        _anotacoesDoDia = dataResults[1] as List<Anotacao>;
      }
    } catch (_) {}
  }

}
