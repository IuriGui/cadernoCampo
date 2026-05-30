import '../../domain/models/atividade/atividade.dart';
import '../services/local/atividade_service.dart';

class AtividadeRepository {

  final AtividadeService _service;

  AtividadeRepository(this._service);

  Future<List<Atividade>> getAll() async {
    final rows = await _service.getAll();
    return rows.map(_toModel).toList();
  }

  Atividade _toModel(Map<String, dynamic> map) => Atividade(
    id: map['id'],
    nome: map['nome'],
    tipo: map['tipo'],
    descricao: map['descricao'],
  );

  Map<String, dynamic> _toMap(Atividade a) => {
    'id': a.id,
    'nome': a.nome,
    'tipo': a.tipo,
    'descricao': a.descricao,
  };

}
