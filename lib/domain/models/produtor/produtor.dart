import 'package:caderno_de_campo/domain/models/propriedade/produtor_propriedade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../usuario/usuario.dart';

part 'produtor.freezed.dart';

@freezed
class Produtor with _$Produtor{
  const factory Produtor({
    required int id,
    required String nome,
    required Usuario usuario,
    required List<ProdutorPropriedade> propriedades
  }) = _Produtor;
}
