import 'package:freezed_annotation/freezed_annotation.dart';


part 'cultura.freezed.dart';


@freezed
class Cultura with _$Cultura{
  const factory Cultura({
    required int id,
    required String nome,
    // TODO adicionar mais algumas coisas
  }) = _Cultura;
}

