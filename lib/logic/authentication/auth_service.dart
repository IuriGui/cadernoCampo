

import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../data/dao/user_dao.dart';
import '../../data/models/user.dart';

class AuthService {
  final UserDAO _userDAO = UserDAO();


  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> register(User user) async {
    try {

      final cleanPassword = user.password.trim();


      await _userDAO.insertUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    String hashedPassword = hashPassword(password.trim());
    return await _userDAO.getUser(email, hashedPassword);
  }
}
