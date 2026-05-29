// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insumo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Insumo {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get unidadeMedida => throw _privateConstructorUsedError;
  Propriedade get propriedade => throw _privateConstructorUsedError;

  /// Create a copy of Insumo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsumoCopyWith<Insumo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsumoCopyWith<$Res> {
  factory $InsumoCopyWith(Insumo value, $Res Function(Insumo) then) =
      _$InsumoCopyWithImpl<$Res, Insumo>;
  @useResult
  $Res call({
    int id,
    String nome,
    String unidadeMedida,
    Propriedade propriedade,
  });

  $PropriedadeCopyWith<$Res> get propriedade;
}

/// @nodoc
class _$InsumoCopyWithImpl<$Res, $Val extends Insumo>
    implements $InsumoCopyWith<$Res> {
  _$InsumoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Insumo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? unidadeMedida = null,
    Object? propriedade = null,
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
            unidadeMedida: null == unidadeMedida
                ? _value.unidadeMedida
                : unidadeMedida // ignore: cast_nullable_to_non_nullable
                      as String,
            propriedade: null == propriedade
                ? _value.propriedade
                : propriedade // ignore: cast_nullable_to_non_nullable
                      as Propriedade,
          )
          as $Val,
    );
  }

  /// Create a copy of Insumo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropriedadeCopyWith<$Res> get propriedade {
    return $PropriedadeCopyWith<$Res>(_value.propriedade, (value) {
      return _then(_value.copyWith(propriedade: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InsumoImplCopyWith<$Res> implements $InsumoCopyWith<$Res> {
  factory _$$InsumoImplCopyWith(
    _$InsumoImpl value,
    $Res Function(_$InsumoImpl) then,
  ) = __$$InsumoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nome,
    String unidadeMedida,
    Propriedade propriedade,
  });

  @override
  $PropriedadeCopyWith<$Res> get propriedade;
}

/// @nodoc
class __$$InsumoImplCopyWithImpl<$Res>
    extends _$InsumoCopyWithImpl<$Res, _$InsumoImpl>
    implements _$$InsumoImplCopyWith<$Res> {
  __$$InsumoImplCopyWithImpl(
    _$InsumoImpl _value,
    $Res Function(_$InsumoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Insumo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? unidadeMedida = null,
    Object? propriedade = null,
  }) {
    return _then(
      _$InsumoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        unidadeMedida: null == unidadeMedida
            ? _value.unidadeMedida
            : unidadeMedida // ignore: cast_nullable_to_non_nullable
                  as String,
        propriedade: null == propriedade
            ? _value.propriedade
            : propriedade // ignore: cast_nullable_to_non_nullable
                  as Propriedade,
      ),
    );
  }
}

/// @nodoc

class _$InsumoImpl implements _Insumo {
  const _$InsumoImpl({
    required this.id,
    required this.nome,
    required this.unidadeMedida,
    required this.propriedade,
  });

  @override
  final int id;
  @override
  final String nome;
  @override
  final String unidadeMedida;
  @override
  final Propriedade propriedade;

  @override
  String toString() {
    return 'Insumo(id: $id, nome: $nome, unidadeMedida: $unidadeMedida, propriedade: $propriedade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsumoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.unidadeMedida, unidadeMedida) ||
                other.unidadeMedida == unidadeMedida) &&
            (identical(other.propriedade, propriedade) ||
                other.propriedade == propriedade));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, nome, unidadeMedida, propriedade);

  /// Create a copy of Insumo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsumoImplCopyWith<_$InsumoImpl> get copyWith =>
      __$$InsumoImplCopyWithImpl<_$InsumoImpl>(this, _$identity);
}

abstract class _Insumo implements Insumo {
  const factory _Insumo({
    required final int id,
    required final String nome,
    required final String unidadeMedida,
    required final Propriedade propriedade,
  }) = _$InsumoImpl;

  @override
  int get id;
  @override
  String get nome;
  @override
  String get unidadeMedida;
  @override
  Propriedade get propriedade;

  /// Create a copy of Insumo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsumoImplCopyWith<_$InsumoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
