import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/propriedade_repository.dart';
import '../../../../domain/models/propriedade/propriedade.dart';
import 'edit_propriedade_view.dart';
import 'edit_propriedade_viewmodel.dart';

class EditPropriedadeScreen extends StatelessWidget {
  final Propriedade propriedade;

  const EditPropriedadeScreen({super.key, required this.propriedade});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditPropriedadeViewModel(
        context.read<PropriedadeRepository>(),
        propriedade,
      ),
      child: const EditPropriedadeView(),
    );
  }
}