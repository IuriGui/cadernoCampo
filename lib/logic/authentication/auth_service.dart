

import '../../data/dao/user_dao.dart';
import '../../data/models/user.dart';

class AuthService {
  final UserDAO _userDAO = UserDAO();

  Future<bool> register(User user) async {
    try {
      await _userDAO.insertUser(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    return await _userDAO.getUser(email, password);
  }
}
