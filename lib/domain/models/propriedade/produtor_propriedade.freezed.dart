// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'produtor_propriedade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProdutorPropriedade {
  Produtor get produtor => throw _privateConstructorUsedError;
  Propriedade get propriedade => throw _privateConstructorUsedError;
  String get papel => throw _privateConstructorUsedError;

  /// Create a copy of ProdutorPropriedade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProdutorPropriedadeCopyWith<ProdutorPropriedade> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProdutorPropriedadeCopyWith<$Res> {
  factory $ProdutorPropriedadeCopyWith(
    ProdutorPropriedade value,
    $Res Function(ProdutorPropriedade) then,
  ) = _$ProdutorPropriedadeCopyWithImpl<$Res, ProdutorPropriedade>;
  @useResult
  $Res call({Produtor produtor, Propriedade propriedade, String papel});

  $ProdutorCopyWith<$Res> get produtor;
  $PropriedadeCopyWith<$Res> get propriedade;
}

/// @nodoc
class _$ProdutorPropriedadeCopyWithImpl<$Res, $Val extends ProdutorPropriedade>
    implements $ProdutorPropriedadeCopyWith<$Res> {
  _$ProdutorPropriedadeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProdutorPropriedade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? produtor = null,
    Object? propriedade = null,
    Object? papel = null,
  }) {
    return _then(
      _value.copyWith(
            produtor: null == produtor
                ? _value.produtor
                : produtor // ignore: cast_nullable_to_non_nullable
                      as Produtor,
            propriedade: null == propriedade
                ? _value.propriedade
                : propriedade // ignore: cast_nullable_to_non_nullable
                      as Propriedade,
            papel: null == papel
                ? _value.papel
                : papel // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of ProdutorPropriedade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProdutorCopyWith<$Res> get produtor {
    return $ProdutorCopyWith<$Res>(_value.produtor, (value) {
      return _then(_value.copyWith(produtor: value) as $Val);
    });
  }

  /// Create a copy of ProdutorPropriedade
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
abstract class _$$ProdutorPropriedadeImplCopyWith<$Res>
    implements $ProdutorPropriedadeCopyWith<$Res> {
  factory _$$ProdutorPropriedadeImplCopyWith(
    _$ProdutorPropriedadeImpl value,
    $Res Function(_$ProdutorPropriedadeImpl) then,
  ) = __$$ProdutorPropriedadeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Produtor produtor, Propriedade propriedade, String papel});

  @override
  $ProdutorCopyWith<$Res> get produtor;
  @override
  $PropriedadeCopyWith<$Res> get propriedade;
}

/// @nodoc
class __$$ProdutorPropriedadeImplCopyWithImpl<$Res>
    extends _$ProdutorPropriedadeCopyWithImpl<$Res, _$ProdutorPropriedadeImpl>
    implements _$$ProdutorPropriedadeImplCopyWith<$Res> {
  __$$ProdutorPropriedadeImplCopyWithImpl(
    _$ProdutorPropriedadeImpl _value,
    $Res Function(_$ProdutorPropriedadeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProdutorPropriedade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? produtor = null,
    Object? propriedade = null,
    Object? papel = null,
  }) {
    return _then(
      _$ProdutorPropriedadeImpl(
        produtor: null == produtor
            ? _value.produtor
            : produtor // ignore: cast_nullable_to_non_nullable
                  as Produtor,
        propriedade: null == propriedade
            ? _value.propriedade
            : propriedade // ignore: cast_nullable_to_non_nullable
                  as Propriedade,
        papel: null == papel
            ? _value.papel
            : papel // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ProdutorPropriedadeImpl implements _ProdutorPropriedade {
  const _$ProdutorPropriedadeImpl({
    required this.produtor,
    required this.propriedade,
    required this.papel,
  });

  @override
  final Produtor produtor;
  @override
  final Propriedade propriedade;
  @override
  final String papel;

  @override
  String toString() {
    return 'ProdutorPropriedade(produtor: $produtor, propriedade: $propriedade, papel: $papel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProdutorPropriedadeImpl &&
            (identical(other.produtor, produtor) ||
                other.produtor == produtor) &&
            (identical(other.propriedade, propriedade) ||
                other.propriedade == propriedade) &&
            (identical(other.papel, papel) || other.papel == papel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, produtor, propriedade, papel);

  /// Create a copy of ProdutorPropriedade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProdutorPropriedadeImplCopyWith<_$ProdutorPropriedadeImpl> get copyWith =>
      __$$ProdutorPropriedadeImplCopyWithImpl<_$ProdutorPropriedadeImpl>(
        this,
        _$identity,
      );
}

abstract class _ProdutorPropriedade implements ProdutorPropriedade {
  const factory _ProdutorPropriedade({
    required final Produtor produtor,
    required final Propriedade propriedade,
    required final String papel,
  }) = _$ProdutorPropriedadeImpl;

  @override
  Produtor get produtor;
  @override
  Propriedade get propriedade;
  @override
  String get papel;

  /// Create a copy of ProdutorPropriedade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProdutorPropriedadeImplCopyWith<_$ProdutorPropriedadeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
