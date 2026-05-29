import 'package:freezed_annotation/freezed_annotation.dart';

import '../propriedade/propriedade.dart';

part 'local.freezed.dart';

@freezed
class Local with _$Local{
  const factory Local({
    required int id,
    required String nome,
    // TODO Definir tipos de locais
    required String tipo,
    required double areaEmMetros,
    required bool quebraVento,
    required bool areaSensivel,
    String? observacoes,
    required Propriedade propriedade,
}) = _local;
}