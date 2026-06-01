import 'package:caderno_de_campo/data/services/local/local_service.dart';
import 'package:caderno_de_campo/data/services/local/propriedade_service.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/local_repository.dart';
import '../../../domain/models/local/local.dart';
import '../../../domain/models/propriedade/propriedade.dart';

class LocalViewmodel extends ChangeNotifier {
  static final LocalRepository _localRepository =
  LocalRepository(
    LocalService(),
    PropriedadeService(),
  );

  final Propriedade propriedade;

  LocalViewmodel(this.propriedade);

  List<Local> locais = [];

  bool isLoading = false;

  Future<void> carregarLocais() async {
    isLoading = true;
    notifyListeners();

    try {
      locais = await _localRepository.getByPropriedade(
        propriedade.id!,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recarregar() async {
    await carregarLocais();
  }
}