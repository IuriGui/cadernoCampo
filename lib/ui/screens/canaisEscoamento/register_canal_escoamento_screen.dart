import 'package:caderno_de_campo/data/dao/canal_escoamento_dao.dart';
import 'package:caderno_de_campo/data/models/canal.dart';
import 'package:caderno_de_campo/data/models/produtor.dart';
import 'package:flutter/material.dart';

import '../../widgets/primary_button.dart';

class RegisterCanalEscoamentoScreen extends StatefulWidget {
  final Produtor produtor;

  const RegisterCanalEscoamentoScreen({super.key, required this.produtor});

  @override
  State<RegisterCanalEscoamentoScreen> createState() =>
      _RegisterCanalEscoamentoScreenState();
}

class _RegisterCanalEscoamentoScreenState
    extends State<RegisterCanalEscoamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();

  bool _isSaving = false;
  String _tipo = 'Cestas';

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  // TODO Puxar do banco
  final List<String> _tipos = [
    'Feira',
    'PNAE',
    'Cestas',
    'CSA',
    'Cooperativa',
    'Associação'
  ];

  List<Widget> _buildFields() {
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return [
      DropdownButtonFormField<String>(
        value: _tipo,
        decoration: const InputDecoration(
          labelText: 'Tipo de Canal',
          prefixIcon: Icon(Icons.category_outlined),
        ),
        items: _tipos
            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
            .toList(),
        onChanged: (v) => setState(() => _tipo = v!),
      ),
      const SizedBox(height: 16),
      Text(_tipo == 'Cestas' ? 'Quantidade de Cestas' : 'Nome do Canal',
          style: labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        controller: _nome,
        decoration: InputDecoration(
          hintText: _tipo == 'Cestas' ? 'Quantidade de cestas' : 'Nome do canal',
          prefixIcon: const Icon(Icons.person_outline),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, informe o nome ou quantidade';
          }
          if (_tipo == 'Cestas' && int.tryParse(value) == null || int.parse(value) <= 0){
            return 'Deve ser um número inteiro maior que zero.';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de canal")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildFields(),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Salvar Canal',
                isLoading: _isSaving,
                onPressed: _saveCanal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCanal() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        final canal = CanalEscoamento(
          nome: _nome.text.trim(),
          tipo: _tipo,
          produtorId: widget.produtor.id!,
        );
        await CanalEscoamentoDAO().insertCanalEscoamento(canal);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Canal salvo com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar canal: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }
}
