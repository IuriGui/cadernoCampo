

import 'package:caderno_de_campo/logic/authentication/auth_service.dart';

import '../../data/dao/produtor_dao.dart';
import '../../data/dao/user_dao.dart';
import '../../data/database/app_database.dart';

class RegistrationService {
  final UserDAO _userDAO = UserDAO();
  final ProdutorDAO _produtorDAO = ProdutorDAO();
  final AuthService _authService = AuthService();

  Future<bool> registerFullData(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;

    return await db.transaction((txn) async {
      try {

        // 1. Inserir Usuário
        final userId = await txn.insert('usuario', {
          'email': data['email'],
          'password': _authService.hashPassword(data['senha']),
        });

        // 2. Inserir Produtor
        final produtorId = await txn.insert('produtor', {
          'usuario_id': userId,
          'nome': data['nomeProdutor'],
        });


        final mecanismo = data['mecanismoControle'] as Map<String, dynamic>;
        await txn.insert('mecanismo_controle', {
          'produtor_id': produtorId,
          'tipo': mecanismo['tipo'],
          'valor': mecanismo['nome'],
        });

        // 6. Programas de Comercialização
        final List<dynamic> programas = data['programas'] ?? [];
        for (var programa in programas) {
          final progMap = programa as Map<String, dynamic>;
          await txn.insert('programa_comercializacao', {
            'produtor_id': produtorId,
            'tipo': progMap['nome'],
            'valor': progMap['detalhe'],
          });
        }

        return true;
      } catch (e) {
        print('Erro na transação de cadastro: $e');
        return false;
      }
    });
  }
}
