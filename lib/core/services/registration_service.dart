import '../database/app_database.dart';
import '../dao/user_dao.dart';
import '../dao/produtor_dao.dart';
import '../dao/propriedade_dao.dart';

class RegistrationService {
  final UserDAO _userDAO = UserDAO();
  final ProdutorDAO _produtorDAO = ProdutorDAO();
  final PropriedadeDAO _propriedadeDAO = PropriedadeDAO();

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


        // // 3. Inserir Propriedade (Opcional)
        // if (data.containsKey('nomePropriedade') && data['nomePropriedade'] != null) {
        //   final propriedadeId = await txn.insert('propriedade', {
        //     'nome': data['nomePropriedade'],
        //     'cidade': data['cidade'],
        //     'cep': data['cep'],
        //     'estado': data['estado'],
        //     'area_total': double.tryParse(data['areaTotal'].toString()) ?? 0.0,
        //     'area_propria': double.tryParse(data['areaPropria'].toString()) ?? 0.0,
        //     'area_arrendada': double.tryParse(data['areaArrendada'].toString()),
        //     'area_producao_vegetal': double.tryParse(data['areaProducao'].toString()),
        //     'observacao': data['observacao'],
        //   });

        //   // 4. Vínculo Produtor-Propriedade (Se a propriedade foi criada)
        //   await txn.insert('produtor_propriedade', {
        //     'propriedade_id': propriedadeId,
        //     'produtor_id': produtorId,
        //     'papel': 'proprietário',
        //   });
        // }

        // 5. Mecanismo de Controle
        await txn.insert('mecanismo_controle', {
          'produtor_id': produtorId,
          'tipo': data['mecanismoControle'],
          'valor': data['mecanismoControle'],
        });

        // 6. Programas de Comercialização
        final List<String> programas = List<String>.from(data['programas'] ?? []);
        for (var programa in programas) {
          await txn.insert('programa_comercializacao', {
            'produtor_id': produtorId,
            'tipo': programa,
            'valor': programa,
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
