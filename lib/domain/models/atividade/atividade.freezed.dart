// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'atividade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Atividade {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;

  /// Create a copy of Atividade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AtividadeCopyWith<Atividade> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AtividadeCopyWith<$Res> {
  factory $AtividadeCopyWith(Atividade value, $Res Function(Atividade) then) =
      _$AtividadeCopyWithImpl<$Res, Atividade>;
  @useResult
  $Res call({int id, String nome, String descricao, String tipo});
}

/// @nodoc
class _$AtividadeCopyWithImpl<$Res, $Val extends Atividade>
    implements $AtividadeCopyWith<$Res> {
  _$AtividadeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Atividade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? descricao = null,
    Object? tipo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            descricao: null == descricao
                ? _value.descricao
                : descricao // ignore: cast_nullable_to_non_nullable
                      as String,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AtividadeImplCopyWith<$Res>
    implements $AtividadeCopyWith<$Res> {
  factory _$$AtividadeImplCopyWith(
    _$AtividadeImpl value,
    $Res Function(_$AtividadeImpl) then,
  ) = __$$AtividadeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nome, String descricao, String tipo});
}

/// @nodoc
class __$$AtividadeImplCopyWithImpl<$Res>
    extends _$AtividadeCopyWithImpl<$Res, _$AtividadeImpl>
    implements _$$AtividadeImplCopyWith<$Res> {
  __$$AtividadeImplCopyWithImpl(
    _$AtividadeImpl _value,
    $Res Function(_$AtividadeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Atividade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? descricao = null,
    Object? tipo = null,
  }) {
    return _then(
      _$AtividadeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        descricao: null == descricao
            ? _value.descricao
            : descricao // ignore: cast_nullable_to_non_nullable
                  as String,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AtividadeImpl implements _Atividade {
  const _$AtividadeImpl({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
  });

  @override
  final int id;
  @override
  final String nome;
  @override
  final String descricao;
  @override
  final String tipo;

  @override
  String toString() {
    return 'Atividade(id: $id, nome: $nome, descricao: $descricao, tipo: $tipo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AtividadeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.tipo, tipo) || other.tipo == tipo));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nome, descricao, tipo);

  /// Create a copy of Atividade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AtividadeImplCopyWith<_$AtividadeImpl> get copyWith =>
      __$$AtividadeImplCopyWithImpl<_$AtividadeImpl>(this, _$identity);
}

abstract class _Atividade implements Atividade {
  const factory _Atividade({
    required final int id,
    required final String nome,
    required final String descricao,
    required final String tipo,
  }) = _$AtividadeImpl;

  @override
  int get id;
  @override
  String get nome;
  @override
  String get descricao;
  @override
  String get tipo;

  /// Create a copy of Atividade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AtividadeImplCopyWith<_$AtividadeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
