import 'package:freezed_annotation/freezed_annotation.dart';


part 'usuario.freezed.dart';

@freezed
class Usuario with _$Usuario{
  const factory Usuario({
    required int id,
    required String email
  }) = _Usuario;
}