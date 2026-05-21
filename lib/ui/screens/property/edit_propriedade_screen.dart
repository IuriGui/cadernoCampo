import 'package:flutter/material.dart';
import '../../../data/dao/propriedade_dao.dart';
import '../../../data/models/propriedade.dart';
import '../../widgets/primary_button.dart';
import '../../../core/constants/estados.dart';

class EditPropriedadeScreen extends StatefulWidget {
  final Propriedade propriedade;
  const EditPropriedadeScreen({super.key, required this.propriedade});

  @override
  State<EditPropriedadeScreen> createState() => _EditPropriedadeScreenState();
}

class _EditPropriedadeScreenState extends State<EditPropriedadeScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController;
  late final _municipioController;
  late final _cepController;
  late final _areaTotalController;
  late final _areaPropriaController;
  late final _areaArrendadaController;
  late final _areaProducaoController;
  late final _obsController;

  String? _estado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.propriedade;
    _nomeController = TextEditingController(text: p.nome);
    _municipioController = TextEditingController(text: p.cidade);
    _cepController = TextEditingController(text: p.cep);
    _areaTotalController = TextEditingController(text: p.areaTotal.toString());
    _areaPropriaController = TextEditingController(text: p.areaPropria.toString());
    _areaArrendadaController = TextEditingController(text: p.areaArrendada?.toString() ?? '');
    _areaProducaoController = TextEditingController(text: p.areaProducaoVegetal?.toString() ?? '');
    _obsController = TextEditingController(text: p.observacao ?? '');
    _estado = p.estado;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _municipioController.dispose();
    _cepController.dispose();
    _areaTotalController.dispose();
    _areaPropriaController.dispose();
    _areaArrendadaController.dispose();
    _areaProducaoController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Propriedade")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Propriedade *'),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _municipioController,
                decoration: const InputDecoration(labelText: 'Cidade *'),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CEP'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: const InputDecoration(labelText: 'Estado *'),
                items: brazilStates.entries.map(
                    (e) => DropdownMenuItem<String>(
                      value: e.value,
                      child: Text(e.value),
                    )
                ).toList()
                ,
                onChanged: (v) => setState(() => _estado = v),
                validator: (v) => v == null ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaTotalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Área total (ha) *'),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaPropriaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Área própria (ha)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaArrendadaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Área arrendada (ha)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaProducaoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Área de produção vegetal (ha)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _obsController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Observações'),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Salvar Alterações',
                isLoading: _isLoading,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updated = Propriedade(
      id: widget.propriedade.id,
      nome: _nomeController.text.trim(),
      cidade: _municipioController.text.trim(),
      cep: _cepController.text.trim(),
      estado: _estado!,
      areaTotal: double.tryParse(_areaTotalController.text) ?? 0.0,
      areaPropria: double.tryParse(_areaPropriaController.text) ?? 0.0,
      areaArrendada: double.tryParse(_areaArrendadaController.text),
      areaProducaoVegetal: double.tryParse(_areaProducaoController.text),
      observacao: _obsController.text.trim(),
    );

    await PropriedadeDAO().updatePropriedade(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Propriedade atualizada com sucesso!')),
      );
      Navigator.pop(context, true);
      setState(() => _isLoading = false);
    }
  }
}