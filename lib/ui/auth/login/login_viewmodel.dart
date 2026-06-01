import 'package:caderno_de_campo/data/repositories/produtor_repository.dart';
import 'package:caderno_de_campo/data/repositories/propriedade_repository.dart';
import 'package:caderno_de_campo/domain/models/produtor/produtor.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../logic/provider/auth_provider.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;


  LoginViewModel(
      this._authRepository
      );

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Produtor? produtorLogado;

  Future<Produtor?> login() async {
    if (!formKey.currentState!.validate()) return null;

    isLoading = true;
    notifyListeners();

    produtorLogado = await _authRepository.login(
      emailController.text,
      passwordController.text,
    );

    isLoading = false;

    notifyListeners();

    print("GOOOOD");
    print(produtorLogado);
    return produtorLogado;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}