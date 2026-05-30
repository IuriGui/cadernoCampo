// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cultura.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Cultura {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;

  /// Create a copy of Cultura
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CulturaCopyWith<Cultura> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CulturaCopyWith<$Res> {
  factory $CulturaCopyWith(Cultura value, $Res Function(Cultura) then) =
      _$CulturaCopyWithImpl<$Res, Cultura>;
  @useResult
  $Res call({int id, String nome, String descricao});
}

/// @nodoc
class _$CulturaCopyWithImpl<$Res, $Val extends Cultura>
    implements $CulturaCopyWith<$Res> {
  _$CulturaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cultura
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? descricao = null,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CulturaImplCopyWith<$Res> implements $CulturaCopyWith<$Res> {
  factory _$$CulturaImplCopyWith(
    _$CulturaImpl value,
    $Res Function(_$CulturaImpl) then,
  ) = __$$CulturaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String nome, String descricao});
}

/// @nodoc
class __$$CulturaImplCopyWithImpl<$Res>
    extends _$CulturaCopyWithImpl<$Res, _$CulturaImpl>
    implements _$$CulturaImplCopyWith<$Res> {
  __$$CulturaImplCopyWithImpl(
    _$CulturaImpl _value,
    $Res Function(_$CulturaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Cultura
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? descricao = null,
  }) {
    return _then(
      _$CulturaImpl(
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
      ),
    );
  }
}

/// @nodoc

class _$CulturaImpl implements _Cultura {
  const _$CulturaImpl({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  @override
  final int id;
  @override
  final String nome;
  @override
  final String descricao;

  @override
  String toString() {
    return 'Cultura(id: $id, nome: $nome, descricao: $descricao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CulturaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nome, descricao);

  /// Create a copy of Cultura
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CulturaImplCopyWith<_$CulturaImpl> get copyWith =>
      __$$CulturaImplCopyWithImpl<_$CulturaImpl>(this, _$identity);
}

abstract class _Cultura implements Cultura {
  const factory _Cultura({
    required final int id,
    required final String nome,
    required final String descricao,
  }) = _$CulturaImpl;

  @override
  int get id;
  @override
  String get nome;
  @override
  String get descricao;

  /// Create a copy of Cultura
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CulturaImplCopyWith<_$CulturaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
