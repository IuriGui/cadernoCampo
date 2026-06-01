import 'package:caderno_de_campo/ui/propriedade/propriedade_view.dart';
import 'package:caderno_de_campo/ui/propriedade/propriedade_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/propriedade_repository.dart';


class PropriedadeScreen extends StatefulWidget {
  final int produtorId;

  const PropriedadeScreen({super.key, required this.produtorId});

  @override
  State<PropriedadeScreen> createState() => _PropriedadeScreenState();
}

class _PropriedadeScreenState extends State<PropriedadeScreen> {
  late final PropriedadeViewmodel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PropriedadeViewmodel(context.read<PropriedadeRepository>(), widget.produtorId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PropriedadeView(
      viewModel: _viewModel,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propriedade cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      },
      onError: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar.'),
            backgroundColor: Colors.red,
          ),
        );
      }, produtorId: _viewModel.produtorId,
    );
  }
}