import '../../domain/models/produtor/produtor.dart';
import '../../domain/models/usuario/usuario.dart';
import '../services/local/produtor_service.dart';

class ProdutorRepository {
  final ProdutorService _service;


  ProdutorRepository(this._service);

  Future<Produtor?> getByUsuario(int usuarioId) async {
    final row = await _service.getByUsuario(usuarioId);
    if (row == null) return null;
    return _toModel(row);
  }

  Future<void> criar(Produtor p) async {
    await _service.insert(_toMap(p));
  }

  Future<void> atualizar(Produtor p) async {
    await _service.update(_toMap(p));
  }

  Future<void> deletar(int id) async {
    await _service.softDelete(id);
  }


  Future<void> adicionarMecanismoControle(int produtorId, String tipo, String valor) async {
    await _service.insertMecanismoControle(produtorId, tipo, valor);
  }

  Produtor _toModel(Map<String, dynamic> map) => Produtor(
    id: map['id'],
    nome: map['nome'],
    usuario: Usuario(
      id: map['usuario_id'],
      email: '',  // a gente precisa?
    ),
    propriedades: const [],
    mecanismoControle: null, // em algum momento será necessário?
  );

  Map<String, dynamic> _toMap(Produtor p) => {
    'id': p.id,
    'nome': p.nome,
    'usuario_id': p.usuario.id,
  };
}