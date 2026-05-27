import 'package:flutter/material.dart';
import '../../../data/dao/area_cultivo_dao.dart';
import '../../../data/models/area_cultivo.dart';
import '../../widgets/primary_button.dart';

class EditAreaScreen extends StatefulWidget {
  final AreaCultivo area;
  const EditAreaScreen({super.key, required this.area});

  @override
  State<EditAreaScreen> createState() => _EditAreaScreenState();
}

class _EditAreaScreenState extends State<EditAreaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.area.nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Área de Cultivo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Área *',
                  prefixIcon: Icon(Icons.drive_file_rename_outline),
                ),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Salvar Alterações',
                isLoading: _isSaving,
                onPressed: _salvar,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final updatedArea = AreaCultivo(
          id: widget.area.id,
          nome: _nomeController.text.trim(),
          localId: widget.area.localId,
          isDeleted: widget.area.isDeleted,
        );

        await AreaCultivoDAO().updateAreaCultivo(updatedArea);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Área atualizada com sucesso!')),
          );
          Navigator.pop(context, updatedArea);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
}
