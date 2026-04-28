import 'package:flutter/material.dart';
import '../../core/dao/propriedade_dao.dart';
import '../../core/models/propriedade.dart';
import '../../core/widgets/primary_button.dart';

class EditPropriedadeScreen extends StatefulWidget {
  final Propriedade propriedade;
  const EditPropriedadeScreen({super.key, required this.propriedade});

  @override
  State<EditPropriedadeScreen> createState() => _EditPropriedadeScreenState();
}

class _EditPropriedadeScreenState extends State<EditPropriedadeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController municipioController;
  late TextEditingController cepController;
  late TextEditingController areaTotalController;
  late TextEditingController areaPropriaController;
  late TextEditingController areaArrendadaController;
  late TextEditingController areaProducaoController;
  late TextEditingController obsController;
  
  String? _estado;
  final List<String> _estados = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.propriedade.nome);
    municipioController = TextEditingController(text: widget.propriedade.municipio);
    cepController = TextEditingController(text: widget.propriedade.cep);
    areaTotalController = TextEditingController(text: widget.propriedade.areaTotal.toString());
    areaPropriaController = TextEditingController(text: widget.propriedade.areaPropria?.toString() ?? '');
    areaArrendadaController = TextEditingController(text: widget.propriedade.areaArrendada?.toString() ?? '');
    areaProducaoController = TextEditingController(text: widget.propriedade.areaProducaoVegetal?.toString() ?? '');
    obsController = TextEditingController(text: widget.propriedade.observacoes ?? '');
    _estado = widget.propriedade.estado;
  }

  @override
  void dispose() {
    nomeController.dispose();
    municipioController.dispose();
    cepController.dispose();
    areaTotalController.dispose();
    areaPropriaController.dispose();
    areaArrendadaController.dispose();
    areaProducaoController.dispose();
    obsController.dispose();
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
              _buildField(nomeController, "Nome da Propriedade", isRequired: true),
              _buildField(municipioController, "Município", isRequired: true),
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

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final updatedPropriedade = Propriedade(
        id: widget.propriedade.id,
        usuarioId: widget.propriedade.usuarioId,
        nome: nomeController.text.trim(),
        municipio: municipioController.text.trim(),
        cep: cepController.text.trim(),
        estado: _estado!,
        areaTotal: double.tryParse(areaTotalController.text) ?? 0.0,
        areaPropria: double.tryParse(areaPropriaController.text),
        areaArrendada: double.tryParse(areaArrendadaController.text),
        areaProducaoVegetal: double.tryParse(areaProducaoController.text),
        observacoes: obsController.text.trim(),
      );

      await PropriedadeDAO().updatePropriedade(updatedPropriedade);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propriedade atualizada com sucesso!')),
        );
        Navigator.pop(context, true); // Retorna true para indicar que houve mudança
      }
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
