import '../database/app_database.dart';
import '../dao/user_dao.dart';
import '../dao/produtor_dao.dart';
import '../dao/propriedade_dao.dart';

class RegistrationService {
  final UserDAO _userDAO = UserDAO();
  final ProdutorDAO _produtorDAO = ProdutorDAO();

  Future<bool> registerFullData(Map<String, dynamic> data) async {
    final db = await AppDatabase().database;

    return await db.transaction((txn) async {
      try {

        // 1. Inserir Usuário
        final userId = await txn.insert('usuario', {
          'email': data['email'],
          'password': data['senha'],
        });

        // 2. Inserir Produtor
        final produtorId = await txn.insert('produtor', {
          'usuario_id': userId,
          'nome': data['nomeProdutor'],
        });


        // 5. Mecanismo de Controle
        // await txn.insert('mecanismo_controle', {
        //   'produtor_id': produtorId,
        //   'tipo': data['mecanismoControle'],
        //   'valor': data['mecanismoControle'],
        // });

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
