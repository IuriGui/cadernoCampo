import 'package:freezed_annotation/freezed_annotation.dart';


part 'propriedade.freezed.dart';

@freezed
class Propriedade with _$Propriedade {
  const factory Propriedade({
    int? id,
    required String nome,
    required String cidade,
    required String estado,
    required String cep,
    required double areaTotal,
    String? observacao,
    double? areaPropria,
    double? areaArrendada,
    double? areaProducaoVegetal,
  }) = _Propriedade;
}
