import 'package:freezed_annotation/freezed_annotation.dart';


part 'atividade.freezed.dart';

@freezed
class Atividade with _$Atividade {
  const factory Atividade({
    required int id,
    required String nome,
    required String descricao,
    required String tipo,
  }) = _Atividade;
}