  import 'package:flutter/material.dart';
  import '../../../../data/repositories/propriedade_repository.dart';
  import '../../../../domain/models/propriedade/propriedade.dart';

  class EditPropriedadeViewModel extends ChangeNotifier {
    final PropriedadeRepository _propriedadeRepository;
    final Propriedade propriedade;

    EditPropriedadeViewModel(this._propriedadeRepository, this.propriedade) {
      nomeController = TextEditingController(text: propriedade.nome);
      municipioController = TextEditingController(text: propriedade.cidade);
      cepController = TextEditingController(text: propriedade.cep);
      areaTotalController = TextEditingController(text: propriedade.areaTotal.toString());
      areaPropriaController = TextEditingController(text: propriedade.areaPropria.toString());
      areaArrendadaController = TextEditingController(text: propriedade.areaArrendada?.toString() ?? '');
      areaProducaoController = TextEditingController(text: propriedade.areaProducaoVegetal?.toString() ?? '');
      obsController = TextEditingController(text: propriedade.observacao ?? '');
      estado = propriedade.estado;
    }

    final formKey = GlobalKey<FormState>();
    late final TextEditingController nomeController;
    late final TextEditingController municipioController;
    late final TextEditingController cepController;
    late final TextEditingController areaTotalController;
    late final TextEditingController areaPropriaController;
    late final TextEditingController areaArrendadaController;
    late final TextEditingController areaProducaoController;
    late final TextEditingController obsController;

    String? estado;
    bool isLoading = false;

    void setEstado(String? value) {
      estado = value;
      notifyListeners();
    }

    Future<bool> salvar() async {
      if (!formKey.currentState!.validate()) return false;

      isLoading = true;
      notifyListeners();

      final updated = Propriedade(
        id: propriedade.id,
        nome: nomeController.text.trim(),
        cidade: municipioController.text.trim(),
        cep: cepController.text.trim(),
        estado: estado!,
        areaTotal: double.tryParse(areaTotalController.text) ?? 0.0,
        areaPropria: double.tryParse(areaPropriaController.text) ?? 0.0,
        areaArrendada: double.tryParse(areaArrendadaController.text),
        areaProducaoVegetal: double.tryParse(areaProducaoController.text),
        observacao: obsController.text.trim(),
      );

      final ok = await _propriedadeRepository.update(updated);

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