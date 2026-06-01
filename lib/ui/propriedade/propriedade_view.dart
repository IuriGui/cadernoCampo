import 'package:caderno_de_campo/ui/propriedade/propriedade_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../../../constants/estados.dart';
import '../widgets/primary_button.dart';


class PropriedadeView extends StatelessWidget {
  final PropriedadeViewmodel viewModel;
  final VoidCallback onSuccess;
  final VoidCallback onError;
  final int produtorId;

  const PropriedadeView({
    super.key,
    required this.viewModel,
    required this.onSuccess,
    required this.onError,
    required this.produtorId,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text("Registro da Propriedade")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: viewModel.nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da Propriedade *'),
                  validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.municipioController,
                  decoration: const InputDecoration(labelText: 'Cidade *'),
                  validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.cepController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'CEP'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: viewModel.estado,
                  decoration: const InputDecoration(labelText: 'Estado *'),
                  items: brazilStates.entries
                      .map((e) => DropdownMenuItem(value: e.value, child: Text(e.value)))
                      .toList(),
                  onChanged: viewModel.setEstado,
                  validator: (v) => v == null ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.areaTotalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Área total (ha) *'),
                  validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.areaPropriaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Área própria (ha)'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.areaArrendadaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Área arrendada (ha)'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.areaProducaoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Área de produção vegetal (ha)'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: viewModel.obsController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Observações'),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Salvar e Finalizar',
                  isLoading: viewModel.isLoading,
                  onPressed: () async {
                    final ok = await viewModel.salvar(produtorId);
                    if (ok) {
                      onSuccess() ;
                    } else {
                      onError();
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