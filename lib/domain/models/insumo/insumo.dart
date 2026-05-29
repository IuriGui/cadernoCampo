import 'package:freezed_annotation/freezed_annotation.dart';

import '../propriedade/propriedade.dart';


part 'insumo.freezed.dart';


@freezed
class Insumo with _$Insumo {
  const factory Insumo({
    required int id,
    required String nome,
    required String unidadeMedida,
    required Propriedade propriedade,
  }) = _Insumo;
}