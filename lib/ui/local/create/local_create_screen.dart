import 'package:caderno_de_campo/ui/local/create/local_create_view.dart';
import 'package:caderno_de_campo/ui/local/create/local_create_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/propriedade/propriedade.dart';

class LocalCreateScreen extends StatelessWidget{

  Propriedade propriedade;

  LocalCreateScreen({super.key, required this.propriedade});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocalCreateViewmodel(propriedade),
      child: LocalCreateView(
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Local cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }, onError: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar.'),
            backgroundColor: Colors.red,
          ),
        );
      },
      ),
    );
  }



}