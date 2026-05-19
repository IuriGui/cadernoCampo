import 'package:flutter/material.dart';
import '../../core/constants/estados.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/constants/estados.dart';
import '../user/register_producer_screen.dart';
import '../../core/dao/produtor_dao.dart';
import '../../core/database/app_database.dart';

class RegisterPropertyScreen extends StatefulWidget {
  final Map<String, String> userData;
  const RegisterPropertyScreen({super.key, required this.userData});

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
    final bool isStandalone = widget.userData.containsKey('userId');

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
                value: _estado,
                decoration: const InputDecoration(labelText: 'Estado *'),
                items: brazilStates
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                label: isStandalone ? 'Salvar e Finalizar' : 'Próximo',
                isLoading: _isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    isStandalone ? _handleStandaloneSave() : _goToNextStep();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterProducerScreen(
          userData: {
            ...widget.userData,
            'nomePropriedade': _nomeController.text,
            'cidade': _municipioController.text,
            'cep': _cepController.text,
            'estado': _estado ?? '',
            'areaTotal': _areaTotalController.text,
            'areaPropria': _areaPropriaController.text,
            'areaArrendada': _areaArrendadaController.text,
            'areaProducao': _areaProducaoController.text,
            'observacao': _obsController.text,
          },
        ),
      ),
    );
  }

  Future<void> _handleStandaloneSave() async {
    setState(() => _isLoading = true);
    try {
      final userId = int.parse(widget.userData['userId']!);
      final produtor = await ProdutorDAO().getProdutorByUsuario(userId);

      if (produtor == null) throw Exception("Produtor não encontrado");

      final db = await AppDatabase().database;
      await db.transaction((txn) async {
        final propriedadeId = await txn.insert('propriedade', {
          'nome': _nomeController.text,
          'cidade': _municipioController.text,
          'cep': _cepController.text,
          'estado': _estado,
          'area_total': double.tryParse(_areaTotalController.text) ?? 0.0,
          'area_propria': double.tryParse(_areaPropriaController.text) ?? 0.0,
          'area_arrendada': double.tryParse(_areaArrendadaController.text),
          'area_producao_vegetal': double.tryParse(_areaProducaoController.text),
          'observacao': _obsController.text,
        });

        await txn.insert('produtor_propriedade', {
          'propriedade_id': propriedadeId,
          'produtor_id': produtor.id,
          'papel': 'proprietário',
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Propriedade cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}