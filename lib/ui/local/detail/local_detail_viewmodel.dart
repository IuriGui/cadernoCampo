


import 'package:caderno_de_campo/data/repositories/area_cultivo_repository.dart';
import 'package:caderno_de_campo/data/repositories/local_repository.dart';
import 'package:caderno_de_campo/data/services/local/area_cultivo_service.dart';
import 'package:caderno_de_campo/domain/models/areaCultivo/area_cultivo.dart';
import 'package:flutter/material.dart';

import '../../../data/services/local/local_service.dart';
import '../../../data/services/local/propriedade_service.dart';
import '../../../domain/models/local/local.dart';

class LocalDetailViewmodel extends ChangeNotifier{

  static final LocalRepository _localRepository =
  LocalRepository(
    LocalService(),
    PropriedadeService(),
  );

  final AreaCultivoRepository _areaCultivoRepository =
    AreaCultivoRepository(AreaCultivoService(), PropriedadeService());



  Local local;

  LocalDetailViewmodel(this.local);

  List<AreaCultivo> areas = [];
  bool isLoading = false;

  Future<void> carregarDetalhes() async {
    isLoading = true;
    notifyListeners();

    try {
      areas = await _areaCultivoRepository.getByLocal(local.id!);
      local = await _localRepository.get(local.id!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recarregar() async {
    await carregarDetalhes();
  }

  Future<void> deletarLocal() async {
   _localRepository.deletar(local.id!);
   await recarregar();
  }

  Future<void> addArea(AreaCultivo area) async {
    await _areaCultivoRepository.criar(area);
    await recarregar();
  }

}
