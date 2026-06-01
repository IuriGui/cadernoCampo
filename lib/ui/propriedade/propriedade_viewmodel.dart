import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/propriedade_repository.dart';
import '../../../domain/models/propriedade/propriedade.dart';
import '../home/home_viewmodel.dart';

class PropriedadeViewmodel extends ChangeNotifier {
  final PropriedadeRepository _propriedadeRepository;
  final int produtorId;

  PropriedadeViewmodel(this._propriedadeRepository, this.produtorId);

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final municipioController = TextEditingController();
  final cepController = TextEditingController();
  final areaTotalController = TextEditingController();
  final areaPropriaController = TextEditingController();
  final areaArrendadaController = TextEditingController();
  final areaProducaoController = TextEditingController();
  final obsController = TextEditingController();

  String? estado;
  bool isLoading = false;

  void setEstado(String? value) {
    estado = value;
    notifyListeners();
  }

  Future<bool> salvar(int usuarioId) async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    notifyListeners();

    final propriedade = Propriedade(
      nome: nomeController.text,
      cidade: municipioController.text,
      cep: cepController.text,
      estado: estado ?? '',
      areaTotal: double.tryParse(areaTotalController.text) ?? 0.0,
      areaPropria: double.tryParse(areaPropriaController.text) ?? 0.0,
      areaArrendada: double.tryParse(areaArrendadaController.text),
      areaProducaoVegetal: double.tryParse(areaProducaoController.text),
      observacao: obsController.text,
    );

    final ok = await _propriedadeRepository.insert(propriedade, produtorId);

    isLoading = false;
    notifyListeners();

    return ok;
  }

  @override
  void dispose() {
    nomeController.dispose();
    municipioController.dispose();
    cepController.dispose();
    areaTotalController.dispose();
    areaPropriaController.dispose();
    areaArrendadaController.dispose();
    areaProducaoController.dispose();
    obsController.dispose();
    super.dispose();
  }
}