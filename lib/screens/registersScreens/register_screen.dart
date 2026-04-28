import 'package:flutter/material.dart';
import '../../core/authentication/auth_service.dart';
import '../../core/models/user.dart';
import '../../core/widgets/primary_button.dart';
import 'register_property_screen.dart';
import '../login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _papel = 'proprietário';
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              const Text("Qual seu papel na propriedade?", style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Proprietário'),
                value: 'proprietário',
                groupValue: _papel,
                onChanged: (v) => setState(() => _papel = v!),
              ),
              RadioListTile<String>(
                title: const Text('Trabalhador'),
                value: 'trabalhador',
                groupValue: _papel,
                onChanged: (v) => setState(() => _papel = v!),
              ),
              RadioListTile<String>(
                title: const Text('Colaborador'),
                value: 'colaborador',
                groupValue: _papel,
                onChanged: (v) => setState(() => _papel = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock_outline)),
                validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: _papel == 'proprietário' ? 'Próximo' : 'Finalizar Cadastro',
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
      if (_papel == 'proprietário') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPropertyScreen(
              userData: {
                'name': nameController.text.trim(),
                'email': emailController.text.trim(),
                'password': passwordController.text,
                'papel': _papel,
              },
            ),
          ),
        );
      } else {
        setState(() => _isLoading = true);
        final user = User(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          papel: _papel,
        );
        final success = await AuthService().register(user);
        setState(() => _isLoading = false);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastro realizado!')));
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false
          );
        }
      }
    }
  }
}
