import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../widgets/primary_button.dart';
import 'local_create_viewmodel.dart';

class LocalCreateView extends StatelessWidget{

  final VoidCallback onSuccess;
  final VoidCallback onError;

  LocalCreateView({
    super.key,
    required this.onSuccess,
    required this.onError,
  });



  bool _temQuebraVento = false;
  bool _temAreaSensivel = false;
  bool _isSaving = false;


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocalCreateViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Local'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: vm.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Identificação',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: vm.nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Local (ex: Roça de Cima) *',
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                ),
                validator: (v) =>
                v == null || v.isEmpty
                    ? '* Obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: vm.tipo ?? vm.tipos.first,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Local',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: vm.tipos.map((t) =>
                    DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: vm.setTipo,
                validator: (v) =>
                v == null || v.isEmpty
                    ? '* Obrigatório'
                    : null,

              ),
              const SizedBox(height: 24),
              const Text(
                'Dimensões e Características',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: vm.areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Área em m² *',
                  prefixIcon: Icon(Icons.square_foot),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return '* Obrigatório';
                  if (double.tryParse(v) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Tem Quebra-vento?'),
                subtitle: const Text('Proteção contra ventos fortes'),
                secondary: Icon(MdiIcons.windPowerOutline),
                value: vm.temQuebraVento,
                onChanged: (v) => vm.setQuebraVento(v),
                // onChanged: (v) => setState(() => _temQuebraVento = v),
              ),
              SwitchListTile(
                title: const Text('Área Sensível?'),
                subtitle: const Text('Ex: Próximo a rios ou casas'),
                secondary: Icon(MdiIcons.alertOutline),
                value: vm.temAreaSensivel,
                onChanged: (v) => vm.setAreaSensivel,
                // onChanged: (v) => setState(() => _temAreaSensivel = v),
              ),
              const SizedBox(height: 24),
              const Text(
                'Outros',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: vm.obsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Salvar Local',
                  isLoading: vm.isSaving,
                onPressed: () async {
                  final ok =  await vm.salvarLocal();
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Local cadastrado com sucesso!'),
                      ),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao salvar local.'),
                      ),
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
