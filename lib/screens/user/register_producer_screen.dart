import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/services/registration_service.dart';
import 'login_screen.dart';

class RegisterProducerScreen extends StatefulWidget {
  final Map<String, String> userData;

  const RegisterProducerScreen({
    super.key,
    required this.userData
  });

  @override
  State<RegisterProducerScreen> createState() => _RegisterProducerScreenState();
}

class _RegisterProducerScreenState extends State<RegisterProducerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registrationService = RegistrationService();
  String _mecanismo = 'OCS';
  bool _isLoading = false;

  final List<String> _programas = ['PNAE', 'PAA', 'Feira Local', 'Exportação'];
  final Map<String, bool> _selecionados = {};

  @override
  void initState() {
    super.initState();
    for (var p in _programas) {
      _selecionados[p] = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Produtor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Mecanismo de Controle:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('OCS'),
                    value: 'OCS',
                    groupValue: _mecanismo,
                    onChanged: (v) => setState(() => _mecanismo = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('SPG'),
                    value: 'SPG',
                    groupValue: _mecanismo,
                    onChanged: (v) => setState(() => _mecanismo = v!),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Programas e Comercialização:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ..._programas.map((p) => CheckboxListTile(
                    title: Text(p),
                    value: _selecionados[p],
                    onChanged: (v) => setState(() => _selecionados[p] = v!),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Finalizar Cadastro',
                isLoading: _isLoading,
                onPressed: _handleFinalizeRegistration,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFinalizeRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final selectedPrograms = _selecionados.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      final fullData = {
        ...widget.userData,
        'mecanismoControle': _mecanismo,
        'programas': selectedPrograms,
      };

      final success = await _registrationService.registerFullData(fullData);

      if (mounted) {
        setState(() => _isLoading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao realizar cadastro. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
