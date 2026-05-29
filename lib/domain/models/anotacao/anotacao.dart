import 'package:freezed_annotation/freezed_annotation.dart';

import '../areaCultivo/area_cultivo.dart';
import '../atividade/atividade.dart';
import '../cultura/cultura.dart';
import '../insumo/insumo.dart';

part 'anotacao.freezed.dart';

@freezed
class Anotacao with _$Anotacao {
  const factory Anotacao({
    required int id,
    required DateTime dataCriacao,
    required Atividade atividade,
    AreaCultivo? areaCultivo,
    Insumo? insumo,
    Cultura? cultura,
    // String? nomeDestino,
    required double quantidade,
    String? unidadeMedida,
    String? observacao,
  }) = _Anotacao;
}