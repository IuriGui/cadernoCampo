import 'package:flutter/material.dart';
import '../../../logic/services/registration_service.dart';
import '../../widgets/primary_button.dart';
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
  final _mecanismoNomeController = TextEditingController();
  
  bool _isLoading = false;


  final Map<String, bool> _selecionados = {};
  final Map<String, TextEditingController> _programControllers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _mecanismoNomeController.dispose();
    for (var controller in _programControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registro de Produtor"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMecanismoControle(),
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

  Widget _buildMecanismoControle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mecanismo de Controle",
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tipo de Mecanismo",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTypeButton('OCS')),
              const SizedBox(width: 8),
              Expanded(child: _buildTypeButton('SPG')),
            ],
          ),
          const SizedBox(height: 16),
          // _buildDashedDivider(),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Nome do Mecanismo",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          _buildTextField(
            controller: _mecanismoNomeController,
            hint: "Nome do mecanismo *",
            icon: Icons.edit_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Row(
      children: List.generate(
        150 ~/ 5,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type) {
    bool isSelected = _mecanismo == type;
    return GestureDetector(
      onTap: () => setState(() => _mecanismo = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : const Color(0xFFE8DCDD),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget _buildProgramasSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Programas e Comercializações",
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       const SizedBox(height: 16),
  //       ..._programas.keys.map((p) => _buildProgramItem(p)),
  //     ],
  //   );
  // }

  // Widget _buildProgramItem(String program) {
  //   bool isSelected = _selecionados[program] ?? false;
  //
  //   return Column(
  //     children: [
  //       CheckboxListTile(
  //         title: Text(program),
  //         value: isSelected,
  //         onChanged: (v) => setState(() => _selecionados[program] = v!),
  //         controlAffinity: ListTileControlAffinity.leading,
  //         contentPadding: EdgeInsets.zero,
  //         activeColor: const Color(0xFF1B5E20),
  //       ),
  //       if (isSelected)
  //         Padding(
  //           padding: const EdgeInsets.only(bottom: 16.0),
  //           child: _buildTextField(
  //             controller: _programControllers[program]!,
  //             hint: fieldHint,
  //           ),
  //         ),
  //     ],
  //   );
  // }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF7CB342)),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Future<void> _handleFinalizeRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final selectedPrograms = _selecionados.entries
          .where((e) => e.value)
          .map((e) {
            return {
              'nome': e.key,
              'detalhe': _programControllers[e.key]!.text,
            };
          })
          .toList();

      final fullData = {
        ...widget.userData,
        'mecanismoControle': {
          'tipo': _mecanismo,
          'nome': _mecanismoNomeController.text,
        },
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
