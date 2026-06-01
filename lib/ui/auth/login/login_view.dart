import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/primary_button.dart';
import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  final LoginViewModel viewModel;
  final VoidCallback onLoginSuccess;
  final VoidCallback onGoToRegister;
  final VoidCallback onForgotPassword;

  const LoginView({
    super.key,
    required this.viewModel,
    required this.onLoginSuccess,
    required this.onGoToRegister,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  const Icon(Icons.eco, size: 100, color: Color(0xFF2E7D32)),
                  const SizedBox(height: 24),
                  Text(
                    'Caderno de Campo',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('E-mail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: viewModel.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Digite seu e-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? '* Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Senha', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: viewModel.passwordController,
                    obscureText: viewModel.obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Digite sua senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: viewModel.toggleObscurePassword,
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? '* Campo obrigatório' : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onForgotPassword,
                      child: const Text('Esqueceu sua senha?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Entrar',
                    isLoading: viewModel.isLoading,
                    onPressed: () async {
                      final produtor = await viewModel.login();
                      if (produtor != null) onLoginSuccess();                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não tem uma conta?'),
                      TextButton(
                        onPressed: onGoToRegister,
                        child: const Text('Cadastre-se'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}