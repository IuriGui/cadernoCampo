import 'dart:developer';
import 'package:caderno_de_campo/data/repositories/produtor_repository.dart';
import 'package:caderno_de_campo/domain/models/produtor/produtor.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/anotacao_repository.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/repositories/propriedade_repository.dart';
import '../../domain/models/anotacao/anotacao.dart';
import '../../domain/models/local/local.dart';
import '../../domain/models/propriedade/propriedade.dart';

class   HomeViewModel extends ChangeNotifier {
  final PropriedadeRepository _propriedadeRepo;
  final LocalRepository _localRepo;
  final AnotacaoRepository _anotacaoRepo;
  final ProdutorRepository _produtorRepository;

  HomeViewModel(
      this._propriedadeRepo,
      this._localRepo,
      this._anotacaoRepo,
      this._produtorRepository,
      );

  bool isLoading = false;
  Propriedade? propriedade;
  List<Local> locais = [];
  List<Anotacao> anotacoesDoDia = [];
  late Produtor produtor;
  String? erro;

  Future<void> carregar(int usuarioId) async {
    isLoading = true;
    notifyListeners();
    try {
      produtor = (await _produtorRepository.getByUsuario(usuarioId))!;
      log(produtor.nome);
      propriedade = await _propriedadeRepo.getByUsuario(usuarioId);

      if (propriedade != null) {
        locais = await _localRepo.getTopThree(propriedade!.id?.toInt() ?? 0);
        anotacoesDoDia = await _anotacaoRepo.getDoDia(propriedade!.id?.toInt() ?? 0);
      }
    } catch (e) {
      erro = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }



  }

  Future<void> refresh(int usuarioId) => carregar(usuarioId);
}