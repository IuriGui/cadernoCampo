import 'package:caderno_de_campo/data/repositories/propriedade_repository.dart';
import 'package:caderno_de_campo/data/services/local/local_service.dart';
import 'package:caderno_de_campo/data/services/local/propriedade_service.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/local_repository.dart';
import '../../../domain/models/local/local.dart';
import '../../../domain/models/propriedade/propriedade.dart';

class LocalCreateViewmodel extends ChangeNotifier {

  Propriedade propriedade;

  LocalCreateViewmodel(this.propriedade);
  final LocalRepository _localRepository = LocalRepository(
      LocalService(), PropriedadeService());
  final PropriedadeRepository _propriedadeRepository = PropriedadeRepository(
      PropriedadeService());

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final areaController = TextEditingController();
  final obsController = TextEditingController();



  final List<String> tipos = [
    'Campo Aberto',
    'Estufa',
    'Pomar',
    'Hidroponia',
    'Vivero',
    'Outro'
  ];

  String? tipo;

  void setTipo(String? value) {
    tipo = value;
    notifyListeners();
  }

  bool _temQuebraVento = false;
  bool _temAreaSensivel = false;
  bool _isSaving = false;
  bool get temQuebraVento => _temQuebraVento;
  bool get temAreaSensivel => _temAreaSensivel;
  bool get isSaving => _isSaving;



  void setQuebraVento(bool value) {
    _temQuebraVento = value;
    notifyListeners();
  }

  void setAreaSensivel(bool value) {
    _temAreaSensivel = value;
    notifyListeners();
  }


  Future<bool> salvarLocal() async {
    if (!formKey.currentState!.validate()) {
      debugPrint('Formulário inválido');
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      final local = Local(
        nome: nomeController.text.trim(),
        areaEmMetros: double.parse(areaController.text),
        tipo: tipo ?? 'Outro',
        quebraVento: _temQuebraVento,
        areaSensivel: _temAreaSensivel,
        observacoes: obsController.text.trim(),
        propriedade: propriedade,
      );

      await _localRepository.insert(local);
      _isSaving = false;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Erro ao salvar local: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

    @override
    void dispose() {
      nomeController.dispose();
      areaController.dispose();
      obsController.dispose();
      super.dispose();
    }
}