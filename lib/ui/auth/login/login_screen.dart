import 'package:caderno_de_campo/ui/auth/login/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../home/home_screen.dart';
import 'login_view.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {

    final viewModel =
    context.read<LoginViewModel>();

    return LoginView(
      viewModel:  viewModel,
      onLoginSuccess: () => Navigator.pushReplacement(
        context,
          MaterialPageRoute(builder: (_) => HomeScreen(usuarioId: viewModel.produtorLogado!.id)),
      ),
      onGoToRegister: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      ),
      onForgotPassword: () {
        // TODO: navegar para recuperação de senha
      },
    );
  }
}

