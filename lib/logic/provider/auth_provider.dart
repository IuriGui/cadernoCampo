// import 'package:flutter/material.dart';
//
// import '../authentication/auth_service.dart';
// import '../../data/dao/produtor_dao.dart';
// import '../../data/dao/propriedade_dao.dart';
// import '../../data/models/propriedade.dart';
// import '../../data/models/user.dart';
//
// class AuthProvider extends ChangeNotifier{
//
//   final AuthService _authService = AuthService();
//
//   User? _user;
//   Propriedade? _propriedade;
//
//   User? get user => _user;
//   Propriedade? get propriedade => _propriedade;
//
//   Future<bool> login(String email, String password) async {
//     final user = await _authService.login(email, password);
//     if (user == null) return false;
//
//     _user = user;
//     _propriedade = await PropriedadeDAO().getPropriedadeByUsuario(user.id!);
//     notifyListeners();
//     return true;
//   }
//
//   Future<bool> registrarPropriedade(Propriedade propriedade) async {
//     try {
//       final produtor = await ProdutorDAO().getProdutorByUsuario(_user!.id!);
//       if (produtor == null) return false;
//
//       await PropriedadeDAO().insertComVinculo(propriedade, produtor.id!);
//
//       _propriedade = await PropriedadeDAO().getPropriedadeByUsuario(_user!.id!);
//       notifyListeners();
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   void logout() {
//     _user = null;
//     _propriedade = null;
//     notifyListeners();
//   }
//
// }