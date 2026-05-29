import 'package:caderno_de_campo/domain/models/produtor/produtor.dart';
import 'package:caderno_de_campo/domain/models/propriedade/propriedade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'produtor_propriedade.freezed.dart';

@freezed
class ProdutorPropriedade with _$ProdutorPropriedade {
  const factory ProdutorPropriedade({
    required Produtor produtor,
    required Propriedade propriedade,
    required String papel,
  }) = _ProdutorPropriedade;
}
