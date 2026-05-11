import 'package:caderno_de_campo/core/models/produtor.dart';

class RegistroUsuario {

  final String? email;
  final String? password;
  final String? confirmPassword;
  final Produtor? produtor;

  RegistroUsuario({
    this.email,
    this.password,
    this.confirmPassword,
    this.produtor,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'produtor': produtor?.toMap(),
    };
  }

}