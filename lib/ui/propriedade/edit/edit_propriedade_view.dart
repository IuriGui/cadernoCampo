import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/estados.dart';
import '../../widgets/primary_button.dart';
import 'edit_propriedade_viewmodel.dart';

class EditPropriedadeView extends StatelessWidget {
  const EditPropriedadeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditPropriedadeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Propriedade'),
      ),
      body: SafeArea(
        child: Form(
          key: vm.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  controller: vm.nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da propriedade *',
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: vm.municipioController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade *',
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: vm.cepController,
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  value: vm.estado,
                  decoration: const InputDecoration(
                    labelText: 'Estado *',
                  ),
                  items: brazilStates.entries
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.value,
                      child: Text(e.value),
                    ),
                  )
                      .toList(),
                  onChanged: vm.setEstado,
                  validator: (v) =>
                  v == null ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: vm.areaTotalController,
                  decoration: const InputDecoration(
                    labelText: 'Área total (ha)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: vm.areaPropriaController,
                  decoration: const InputDecoration(
                    labelText: 'Área própria (ha)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: vm.areaArrendadaController,
                  decoration: const InputDecoration(
                    labelText: 'Área arrendada (ha)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: vm.areaProducaoController,
                  decoration: const InputDecoration(
                    labelText: 'Área produção vegetal (ha)'
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 36),

                PrimaryButton(
                  label: 'Salvar Alterações',
                  isLoading: vm.isLoading,
                  onPressed: () async {
                    final ok = await vm.salvar();

                    if (!context.mounted) return;

                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Propriedade atualizada com sucesso',
                          ),
                        ),
                      );

                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Erro ao atualizar propriedade',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}