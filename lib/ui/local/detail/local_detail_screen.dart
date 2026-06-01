

import 'package:caderno_de_campo/ui/auth/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/local/local.dart';
import '../../home/home_viewmodel.dart';
import 'local_detail_view.dart';
import 'local_detail_viewmodel.dart';

class LocalDetailScreen extends StatelessWidget{

  final Local local;

  const LocalDetailScreen({super.key, required this.local});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocalDetailViewmodel(local)
        ..carregarDetalhes(),
      child: LocalDetailView(
        local: local,
        produtor: context.read<LoginViewModel>().produtorLogado!
      )
    );

  }


}