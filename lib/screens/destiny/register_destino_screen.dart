import 'package:flutter/material.dart';
import '../../core/dao/destino_dao.dart';
import '../../core/models/destino.dart';
import '../../core/widgets/primary_button.dart';

class RegisterDestinoScreen extends StatefulWidget {
  const RegisterDestinoScreen({super.key});

  @override
  State<RegisterDestinoScreen> createState() => _RegisterDestinoScreenState();
}

class _RegisterDestinoScreenState extends State<RegisterDestinoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        await DestinoDAO().insertDestino(Destino(nome: _nomeController.text.trim()));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Destino cadastrado com sucesso!')),
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
      appBar: AppBar(title: const Text('Novo Destino')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Destino',
                  prefixIcon: Icon(Icons.location_on_outlined),
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
