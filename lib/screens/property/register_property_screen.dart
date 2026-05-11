import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';
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
  final nomeController = TextEditingController();
  final municipioController = TextEditingController();
  final cepController = TextEditingController();
  final areaTotalController = TextEditingController();
  final areaPropriaController = TextEditingController();
  final areaArrendadaController = TextEditingController();
  final areaProducaoController = TextEditingController();
  final obsController = TextEditingController();
  
  bool _isLoading = false;
  String? _estado;
  final List<String> _estados = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

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
              _buildField(nomeController, "Nome da Propriedade", isRequired: true),
              _buildField(municipioController, "Cidade", isRequired: true),
              _buildField(cepController, "CEP", keyboardType: TextInputType.number),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: const InputDecoration(labelText: 'Estado *'),
                items: _estados.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _estado = v),
                validator: (v) => v == null ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              _buildField(areaTotalController, "Área total (ha)", isRequired: true, keyboardType: TextInputType.number),
              _buildField(areaPropriaController, "Área própria (ha)", keyboardType: TextInputType.number),
              _buildField(areaArrendadaController, "Área arrendada (ha)", keyboardType: TextInputType.number),
              _buildField(areaProducaoController, "Área de produção vegetal (ha)", keyboardType: TextInputType.number),
              _buildField(obsController, "Observações", maxLines: 3),
              const SizedBox(height: 32),
              PrimaryButton(
                label: isStandalone ? 'Salvar e Finalizar' : 'Próximo',
                isLoading: _isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isStandalone) {
                      _handleStandaloneSave();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterProducerScreen(
                            userData: {
                              ...widget.userData,
                              'nomePropriedade': nomeController.text,
                              'cidade': municipioController.text,
                              'cep': cepController.text,
                              'estado': _estado ?? '',
                              'areaTotal': areaTotalController.text,
                              'areaPropria': areaPropriaController.text,
                              'areaArrendada': areaArrendadaController.text,
                              'areaProducao': areaProducaoController.text,
                              'observacao': obsController.text,
                            }
                          ),
                        ),
                      );
                    }
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
    setState(() => _isLoading = true);
    try {
      final userId = int.parse(widget.userData['userId']!);
      final produtor = await ProdutorDAO().getProdutorByUsuario(userId);
      
      if (produtor == null) throw Exception("Produtor não encontrado");

      final db = await AppDatabase().database;
      await db.transaction((txn) async {
        final propriedadeId = await txn.insert('propriedade', {
          'nome': nomeController.text,
          'cidade': municipioController.text,
          'cep': cepController.text,
          'estado': _estado,
          'area_total': double.tryParse(areaTotalController.text) ?? 0.0,
          'area_propria': double.tryParse(areaPropriaController.text) ?? 0.0,
          'area_arrendada': double.tryParse(areaArrendadaController.text),
          'area_producao_vegetal': double.tryParse(areaProducaoController.text),
          'observacao': obsController.text,
        });

        await txn.insert('produtor_propriedade', {
          'propriedade_id': propriedadeId,
          'produtor_id': produtor.id,
          'papel': 'proprietário',
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propriedade cadastrada com sucesso!'), backgroundColor: Colors.green),
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

  Widget _buildField(TextEditingController controller, String label, {bool isRequired = false, TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: isRequired ? "$label *" : label),
        validator: (v) => isRequired && (v == null || v.isEmpty) ? '* Obrigatório' : null,
      ),
    );
  }
}
