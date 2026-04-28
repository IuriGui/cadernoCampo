import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/local_dao.dart';
import '../../core/models/local.dart';
import '../../core/models/propriedade.dart';
import '../../core/widgets/primary_button.dart';

class RegisterLocalScreen extends StatefulWidget {
  final Propriedade propriedade;
  const RegisterLocalScreen({super.key, required this.propriedade});

  @override
  State<RegisterLocalScreen> createState() => _RegisterLocalScreenState();
}

class _RegisterLocalScreenState extends State<RegisterLocalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _areaController = TextEditingController();
  final _obsController = TextEditingController();
  
  String _tipo = 'Campo Aberto';
  bool _temQuebraVento = false;
  bool _temAreaSensivel = false;
  bool _isSaving = false;

  final List<String> _tipos = [
    'Campo Aberto',
    'Estufa',
    'Pomar',
    'Hidroponia',
    'Vivero',
    'Outro'
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _areaController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Local'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Identificação',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Local (ex: Roça de Cima) *',
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                ),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Local',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _tipos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _tipo = v!),
              ),
              const SizedBox(height: 24),
              const Text(
                'Dimensões e Características',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Área em m² *',
                  prefixIcon: Icon(Icons.square_foot),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return '* Obrigatório';
                  if (double.tryParse(v) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Tem Quebra-vento?'),
                subtitle: const Text('Proteção contra ventos fortes'),
                secondary: Icon(MdiIcons.windPowerOutline),
                value: _temQuebraVento,
                onChanged: (v) => setState(() => _temQuebraVento = v),
              ),
              SwitchListTile(
                title: const Text('Área Sensível?'),
                subtitle: const Text('Ex: Próximo a rios ou casas'),
                secondary: Icon(MdiIcons.alertOutline),
                value: _temAreaSensivel,
                onChanged: (v) => setState(() => _temAreaSensivel = v),
              ),
              const SizedBox(height: 24),
              const Text(
                'Outros',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _obsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Salvar Local',
                isLoading: _isSaving,
                onPressed: _salvarLocal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvarLocal() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      try {
        final local = Local(
          nome: _nomeController.text.trim(),
          areaM2: double.parse(_areaController.text),
          tipo: _tipo,
          temQuebraVento: _temQuebraVento,
          temAreaSensivel: _temAreaSensivel,
          observacoes: _obsController.text.trim(),
          propriedadeId: widget.propriedade.id!,
        );

        await LocalDAO().insertLocal(local);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Local cadastrado com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar local: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
}
