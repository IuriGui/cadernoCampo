import 'package:freezed_annotation/freezed_annotation.dart';

import '../propriedade/propriedade.dart';


part 'area_cultivo.freezed.dart';


@freezed
class AreaCultivo with _$AreaCultivo {
  const factory AreaCultivo({
    required int id,
    required String nome,
    required Propriedade propriedade,
}) = _AreaCultivo;

}


