// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mecanismo_controle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MecanismoControle {
  int get id => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;
  String get valor => throw _privateConstructorUsedError;
  Produtor get produtor => throw _privateConstructorUsedError;

  /// Create a copy of MecanismoControle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MecanismoControleCopyWith<MecanismoControle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MecanismoControleCopyWith<$Res> {
  factory $MecanismoControleCopyWith(
    MecanismoControle value,
    $Res Function(MecanismoControle) then,
  ) = _$MecanismoControleCopyWithImpl<$Res, MecanismoControle>;
  @useResult
  $Res call({int id, String tipo, String valor, Produtor produtor});

  $ProdutorCopyWith<$Res> get produtor;
}

/// @nodoc
class _$MecanismoControleCopyWithImpl<$Res, $Val extends MecanismoControle>
    implements $MecanismoControleCopyWith<$Res> {
  _$MecanismoControleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MecanismoControle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tipo = null,
    Object? valor = null,
    Object? produtor = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
            valor: null == valor
                ? _value.valor
                : valor // ignore: cast_nullable_to_non_nullable
                      as String,
            produtor: null == produtor
                ? _value.produtor
                : produtor // ignore: cast_nullable_to_non_nullable
                      as Produtor,
          )
          as $Val,
    );
  }

  /// Create a copy of MecanismoControle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProdutorCopyWith<$Res> get produtor {
    return $ProdutorCopyWith<$Res>(_value.produtor, (value) {
      return _then(_value.copyWith(produtor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MecanismoControleImplCopyWith<$Res>
    implements $MecanismoControleCopyWith<$Res> {
  factory _$$MecanismoControleImplCopyWith(
    _$MecanismoControleImpl value,
    $Res Function(_$MecanismoControleImpl) then,
  ) = __$$MecanismoControleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String tipo, String valor, Produtor produtor});

  @override
  $ProdutorCopyWith<$Res> get produtor;
}

/// @nodoc
class __$$MecanismoControleImplCopyWithImpl<$Res>
    extends _$MecanismoControleCopyWithImpl<$Res, _$MecanismoControleImpl>
    implements _$$MecanismoControleImplCopyWith<$Res> {
  __$$MecanismoControleImplCopyWithImpl(
    _$MecanismoControleImpl _value,
    $Res Function(_$MecanismoControleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MecanismoControle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tipo = null,
    Object? valor = null,
    Object? produtor = null,
  }) {
    return _then(
      _$MecanismoControleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
        valor: null == valor
            ? _value.valor
            : valor // ignore: cast_nullable_to_non_nullable
                  as String,
        produtor: null == produtor
            ? _value.produtor
            : produtor // ignore: cast_nullable_to_non_nullable
                  as Produtor,
      ),
    );
  }
}

/// @nodoc

class _$MecanismoControleImpl implements _MecanismoControle {
  const _$MecanismoControleImpl({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.produtor,
  });

  @override
  final int id;
  @override
  final String tipo;
  @override
  final String valor;
  @override
  final Produtor produtor;

  @override
  String toString() {
    return 'MecanismoControle(id: $id, tipo: $tipo, valor: $valor, produtor: $produtor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MecanismoControleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.produtor, produtor) ||
                other.produtor == produtor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, tipo, valor, produtor);

  /// Create a copy of MecanismoControle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MecanismoControleImplCopyWith<_$MecanismoControleImpl> get copyWith =>
      __$$MecanismoControleImplCopyWithImpl<_$MecanismoControleImpl>(
        this,
        _$identity,
      );
}

abstract class _MecanismoControle implements MecanismoControle {
  const factory _MecanismoControle({
    required final int id,
    required final String tipo,
    required final String valor,
    required final Produtor produtor,
  }) = _$MecanismoControleImpl;

  @override
  int get id;
  @override
  String get tipo;
  @override
  String get valor;
  @override
  Produtor get produtor;

  /// Create a copy of MecanismoControle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MecanismoControleImplCopyWith<_$MecanismoControleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
