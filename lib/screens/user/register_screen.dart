import 'package:caderno_de_campo/screens/user/register_producer_screen.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  final bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  List<Widget> _buildFields() {
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return [
      const Text('Nome', style: labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Digite seu nome completo',
          prefixIcon: Icon(Icons.person_outline),
        ),
        validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
      ),
      const SizedBox(height: 16),
      const Text('E-mail', style: labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Digite seu e-mail',
          prefixIcon: Icon(Icons.email_outlined),
        ),
        validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
      ),
      const SizedBox(height: 16),
      const Text('Senha', style: labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: 'Crie uma senha',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        validator: (value) =>
            value != null && value.length >= 6 ? null : 'Senha muito curta',
      ),
      const SizedBox(height: 16),
      const Text('Confirmar Senha', style: labelStyle),
      const SizedBox(height: 8),
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: 'Repita sua senha',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        validator: (value) =>
            value == _passwordController.text ? null : 'As senhas não coincidem',
      ),
      const SizedBox(height: 32),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Usuário")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildFields(),
              PrimaryButton(
                label: 'Próximo',
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterProducerScreen(
            userData: {
              'nomeProdutor': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'senha': _passwordController.text.trim()
            },
          ),
        ),
      );
    }
  }
}
