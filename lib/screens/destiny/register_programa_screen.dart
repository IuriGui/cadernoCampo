import 'package:flutter/material.dart';
import '../../core/dao/produtor_dao.dart';
import '../../core/widgets/primary_button.dart';

class RegisterProgramaScreen extends StatefulWidget {
  final int produtorId;
  const RegisterProgramaScreen({super.key, required this.produtorId});

  @override
  State<RegisterProgramaScreen> createState() => _RegisterProgramaScreenState();
}

class _RegisterProgramaScreenState extends State<RegisterProgramaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();
  final _valorController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _tipoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await ProdutorDAO().insertProgramaComercializacao(
          widget.produtorId,
          _tipoController.text.trim(),
          _valorController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Programa cadastrado com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Programa')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tipoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Programa',
                  hintText: 'Ex: PAA, PNAE...',
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor/Descrição',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Salvar',
                isLoading: _isSaving,
                onPressed: _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
