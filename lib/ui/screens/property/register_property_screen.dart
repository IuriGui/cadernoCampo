import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/estados.dart';
import '../../../data/models/propriedade.dart';
import '../../../logic/provider/auth_provider.dart';
import '../../widgets/primary_button.dart';


class RegisterPropertyScreen extends StatefulWidget {
  const RegisterPropertyScreen({super.key});

  @override
  State<RegisterPropertyScreen> createState() => _RegisterPropertyScreenState();
}

class _RegisterPropertyScreenState extends State<RegisterPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _municipioController = TextEditingController();
  final _cepController = TextEditingController();
  final _areaTotalController = TextEditingController();
  final _areaPropriaController = TextEditingController();
  final _areaArrendadaController = TextEditingController();
  final _areaProducaoController = TextEditingController();
  final _obsController = TextEditingController();

  bool _isLoading = false;
  String? _estado;

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
    //final bool isStandalone = widget.userData.containsKey('userId');

    return Scaffold(
      appBar: AppBar(title: const Text("Registro da Propriedade")),
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
                items: brazilStates.entries
                    .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                    .toList(),
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
                label: 'Salvar e Finalizar',
                isLoading: _isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _handleStandaloneSave();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _handleStandaloneSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final propriedade = Propriedade(
      nome: _nomeController.text,
      cidade: _municipioController.text,
      cep: _cepController.text,
      estado: _estado ?? '',
      areaTotal: double.tryParse(_areaTotalController.text) ?? 0.0,
      areaPropria: double.tryParse(_areaPropriaController.text) ?? 0.0,
      areaArrendada: double.tryParse(_areaArrendadaController.text),
      areaProducaoVegetal: double.tryParse(_areaProducaoController.text),
      observacao: _obsController.text,
    );

    final ok = await context.read<AuthProvider>().registrarPropriedade(
        propriedade);

    if (mounted) {
      setState(() => _isLoading = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propriedade cadastrada com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar.'), backgroundColor: Colors.red),
        );
      }
    }
  }
}