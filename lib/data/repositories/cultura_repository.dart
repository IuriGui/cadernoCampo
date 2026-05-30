import 'package:caderno_de_campo/data/services/local/cultura_service.dart';
import 'package:caderno_de_campo/domain/models/cultura/cultura.dart';

class CulturaRepository {

  final CulturaService _service;

  CulturaRepository(this._service);

  Future<List<Cultura>> getAll() async {
    final rows = await _service.getAll();
    return rows.map(_toModel).toList();
  }

  Cultura _toModel(Map<String, dynamic> map) => Cultura(
    id: map['id'],
    nome: map['nome'],
    descricao: map['descricao'],
  );
}