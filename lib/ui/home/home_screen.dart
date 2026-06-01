import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/anotacao_repository.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/repositories/produtor_repository.dart';
import '../../data/repositories/propriedade_repository.dart';
import 'home_view.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final int usuarioId;

  const HomeScreen({super.key, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context.read<PropriedadeRepository>(),
        context.read<LocalRepository>(),
        context.read<AnotacaoRepository>(),
        context.read<ProdutorRepository>(),
      )..carregar(usuarioId),
      child: HomeView(),
    );
  }
}