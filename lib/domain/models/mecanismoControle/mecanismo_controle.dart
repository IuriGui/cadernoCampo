import 'package:freezed_annotation/freezed_annotation.dart';

import '../produtor/produtor.dart';

part 'mecanismo_controle.freezed.dart';

@freezed
class MecanismoControle with _$MecanismoControle{
  const factory MecanismoControle({
    required int id,
    required String tipo,
    required String valor,
    required Produtor produtor,
  }) = _MecanismoControle;
}
