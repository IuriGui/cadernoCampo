// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'area_cultivo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AreaCultivo {
  int? get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  int get localId => throw _privateConstructorUsedError;

  /// Create a copy of AreaCultivo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AreaCultivoCopyWith<AreaCultivo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AreaCultivoCopyWith<$Res> {
  factory $AreaCultivoCopyWith(
    AreaCultivo value,
    $Res Function(AreaCultivo) then,
  ) = _$AreaCultivoCopyWithImpl<$Res, AreaCultivo>;
  @useResult
  $Res call({int? id, String nome, int localId});
}

/// @nodoc
class _$AreaCultivoCopyWithImpl<$Res, $Val extends AreaCultivo>
    implements $AreaCultivoCopyWith<$Res> {
  _$AreaCultivoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AreaCultivo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nome = null,
    Object? localId = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            localId: null == localId
                ? _value.localId
                : localId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AreaCultivoImplCopyWith<$Res>
    implements $AreaCultivoCopyWith<$Res> {
  factory _$$AreaCultivoImplCopyWith(
    _$AreaCultivoImpl value,
    $Res Function(_$AreaCultivoImpl) then,
  ) = __$$AreaCultivoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String nome, int localId});
}

/// @nodoc
class __$$AreaCultivoImplCopyWithImpl<$Res>
    extends _$AreaCultivoCopyWithImpl<$Res, _$AreaCultivoImpl>
    implements _$$AreaCultivoImplCopyWith<$Res> {
  __$$AreaCultivoImplCopyWithImpl(
    _$AreaCultivoImpl _value,
    $Res Function(_$AreaCultivoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AreaCultivo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nome = null,
    Object? localId = null,
  }) {
    return _then(
      _$AreaCultivoImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        localId: null == localId
            ? _value.localId
            : localId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AreaCultivoImpl implements _AreaCultivo {
  const _$AreaCultivoImpl({this.id, required this.nome, required this.localId});

  @override
  final int? id;
  @override
  final String nome;
  @override
  final int localId;

  @override
  String toString() {
    return 'AreaCultivo(id: $id, nome: $nome, localId: $localId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AreaCultivoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.localId, localId) || other.localId == localId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nome, localId);

  /// Create a copy of AreaCultivo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AreaCultivoImplCopyWith<_$AreaCultivoImpl> get copyWith =>
      __$$AreaCultivoImplCopyWithImpl<_$AreaCultivoImpl>(this, _$identity);
}

abstract class _AreaCultivo implements AreaCultivo {
  const factory _AreaCultivo({
    final int? id,
    required final String nome,
    required final int localId,
  }) = _$AreaCultivoImpl;

  @override
  int? get id;
  @override
  String get nome;
  @override
  int get localId;

  /// Create a copy of AreaCultivo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AreaCultivoImplCopyWith<_$AreaCultivoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
