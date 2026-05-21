import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/dao/insumo_dao.dart';
import '../../../data/models/insumo.dart';
import '../../../data/models/propriedade.dart';
import '../../widgets/primary_button.dart';

class RegisterInsumoScreen extends StatefulWidget {
  final Propriedade propriedade;
  const RegisterInsumoScreen({super.key, required this.propriedade});

  @override
  State<RegisterInsumoScreen> createState() => _RegisterInsumoScreenState();
}

class _RegisterInsumoScreenState extends State<RegisterInsumoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _produtoController = TextEditingController();
  final _fornecedorController = TextEditingController();
  DateTime _dataAquisicao = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _produtoController.dispose();
    _fornecedorController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataAquisicao,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dataAquisicao) {
      setState(() {
        _dataAquisicao = picked;
      });
    }
  }

  Future<void> _salvarInsumo() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      try {
        final insumo = Insumo(
          produto: _produtoController.text.trim(),
          fornecedor: _fornecedorController.text.trim(),
          dataAquisicao: _dataAquisicao,
          propriedadeId: widget.propriedade.id,
        );

        final id = await InsumoDAO().insertInsumo(insumo);
        final insumoComId = Insumo(
          id: id,
          produto: insumo.produto,
          fornecedor: insumo.fornecedor,
          dataAquisicao: insumo.dataAquisicao,
          propriedadeId: insumo.propriedadeId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insumo cadastrado com sucesso!')),
          );
          Navigator.pop(context, insumoComId);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar insumo: $e')),
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
      appBar: AppBar(
        title: const Text('Cadastrar Insumo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Informações do Insumo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _produtoController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Produto *',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fornecedorController,
                  decoration: const InputDecoration(
                    labelText: 'Fornecedor *',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data de Aquisição',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(_dataAquisicao)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  label: 'Salvar Insumo',
                  isLoading: _isSaving,
                  onPressed: _salvarInsumo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
