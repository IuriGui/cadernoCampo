import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../domain/models/mecanismoControle/mecanismo_controle.dart';
import '../../domain/models/produtor/produtor.dart';
import '../../domain/models/usuario/usuario.dart';
import '../services/local/produtor_service.dart';
import '../services/local/usuario_service.dart';

class AuthRepository {
  final UsuarioService _usuarioService;
  final ProdutorService _produtorService;

  AuthRepository(this._usuarioService, this._produtorService);

  // Tenta logar — retorna o Produtor se credenciais válidas, null se não
  Future<Produtor?> login(String email, String password) async {
    final hashed = _hashPassword(password);
    final userRow = await _usuarioService.getByEmailAndPassword(email, hashed);
    if (userRow == null) return null;

    final produtorRow = await _produtorService.getByUsuario(userRow['id']);
    if (produtorRow == null) return null;

    final mecanismoRow = await _produtorService
        .getMecanismoControleByProdutor(produtorRow['id']);

    return Produtor(
      id: produtorRow['id'],
      nome: produtorRow['nome'],
      usuario: Usuario(
        id: userRow['id'],
        email: userRow['email'],
      ),
      mecanismoControle: MecanismoControle(
          id: mecanismoRow!['id'],
          tipo: mecanismoRow['tipo'],
          valor: mecanismoRow['valor'],
      ),
      propriedades: const [],
    );
  }


  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> cadastrar(String email, String password, String nome,
      String mecanismoTipo,
      String mecanismoValor,) async {

    final hashed = _hashPassword(password); // Hash da senha

    final usuarioId = await _usuarioService.insert({
      'email': email,
      'password': hashed,
    });

    final produtorId = await _produtorService.insert({
      'nome': nome,
      'usuario_id': usuarioId,
    });

    await _produtorService.insertMecanismoControle(
      produtorId,
      mecanismoTipo,
      mecanismoValor,
    );

  }
}