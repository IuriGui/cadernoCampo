import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../propriedade/register_propriedade_screen.dart';
import '../home_viewmodel.dart';

class NoPropertyView extends StatelessWidget {
  const NoPropertyView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Icon(MdiIcons.homeAlertOutline, size: 100, color: Colors.orange),
        const SizedBox(height: 24),
        const Text(
          'Bem-vindo!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Voce ainda nao possui uma propriedade vinculada. Para comecar a registrar suas atividades, escolha uma das opcoes abaixo:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PropriedadeScreen(produtorId: vm.produtor.id),
              ),
            );
            if (result == true) vm.refresh(vm.produtor.usuario.id);
          },
          icon: const Icon(Icons.add_business_outlined),
          label: const Text('Cadastrar Minha Propriedade'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Funcionalidade de solicitacao de acesso em breve!',
              ),
            ),
          ),
          icon: const Icon(Icons.person_search_outlined),
          label: const Text('Pedir Acesso a um Proprietario'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2E7D32),
            side: const BorderSide(color: Color(0xFF2E7D32)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}


