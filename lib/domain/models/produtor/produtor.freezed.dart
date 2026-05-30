// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'produtor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Produtor {
  int get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  Usuario get usuario => throw _privateConstructorUsedError;
  MecanismoControle? get mecanismoControle =>
      throw _privateConstructorUsedError;
  List<ProdutorPropriedade> get propriedades =>
      throw _privateConstructorUsedError;

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProdutorCopyWith<Produtor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProdutorCopyWith<$Res> {
  factory $ProdutorCopyWith(Produtor value, $Res Function(Produtor) then) =
      _$ProdutorCopyWithImpl<$Res, Produtor>;
  @useResult
  $Res call({
    int id,
    String nome,
    Usuario usuario,
    MecanismoControle? mecanismoControle,
    List<ProdutorPropriedade> propriedades,
  });

  $UsuarioCopyWith<$Res> get usuario;
  $MecanismoControleCopyWith<$Res>? get mecanismoControle;
}

/// @nodoc
class _$ProdutorCopyWithImpl<$Res, $Val extends Produtor>
    implements $ProdutorCopyWith<$Res> {
  _$ProdutorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? usuario = null,
    Object? mecanismoControle = freezed,
    Object? propriedades = null,
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
            usuario: null == usuario
                ? _value.usuario
                : usuario // ignore: cast_nullable_to_non_nullable
                      as Usuario,
            mecanismoControle: freezed == mecanismoControle
                ? _value.mecanismoControle
                : mecanismoControle // ignore: cast_nullable_to_non_nullable
                      as MecanismoControle?,
            propriedades: null == propriedades
                ? _value.propriedades
                : propriedades // ignore: cast_nullable_to_non_nullable
                      as List<ProdutorPropriedade>,
          )
          as $Val,
    );
  }

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsuarioCopyWith<$Res> get usuario {
    return $UsuarioCopyWith<$Res>(_value.usuario, (value) {
      return _then(_value.copyWith(usuario: value) as $Val);
    });
  }

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MecanismoControleCopyWith<$Res>? get mecanismoControle {
    if (_value.mecanismoControle == null) {
      return null;
    }

    return $MecanismoControleCopyWith<$Res>(_value.mecanismoControle!, (value) {
      return _then(_value.copyWith(mecanismoControle: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProdutorImplCopyWith<$Res>
    implements $ProdutorCopyWith<$Res> {
  factory _$$ProdutorImplCopyWith(
    _$ProdutorImpl value,
    $Res Function(_$ProdutorImpl) then,
  ) = __$$ProdutorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String nome,
    Usuario usuario,
    MecanismoControle? mecanismoControle,
    List<ProdutorPropriedade> propriedades,
  });

  @override
  $UsuarioCopyWith<$Res> get usuario;
  @override
  $MecanismoControleCopyWith<$Res>? get mecanismoControle;
}

/// @nodoc
class __$$ProdutorImplCopyWithImpl<$Res>
    extends _$ProdutorCopyWithImpl<$Res, _$ProdutorImpl>
    implements _$$ProdutorImplCopyWith<$Res> {
  __$$ProdutorImplCopyWithImpl(
    _$ProdutorImpl _value,
    $Res Function(_$ProdutorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? usuario = null,
    Object? mecanismoControle = freezed,
    Object? propriedades = null,
  }) {
    return _then(
      _$ProdutorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        usuario: null == usuario
            ? _value.usuario
            : usuario // ignore: cast_nullable_to_non_nullable
                  as Usuario,
        mecanismoControle: freezed == mecanismoControle
            ? _value.mecanismoControle
            : mecanismoControle // ignore: cast_nullable_to_non_nullable
                  as MecanismoControle?,
        propriedades: null == propriedades
            ? _value._propriedades
            : propriedades // ignore: cast_nullable_to_non_nullable
                  as List<ProdutorPropriedade>,
      ),
    );
  }
}

/// @nodoc

class _$ProdutorImpl implements _Produtor {
  const _$ProdutorImpl({
    required this.id,
    required this.nome,
    required this.usuario,
    required this.mecanismoControle,
    required final List<ProdutorPropriedade> propriedades,
  }) : _propriedades = propriedades;

  @override
  final int id;
  @override
  final String nome;
  @override
  final Usuario usuario;
  @override
  final MecanismoControle? mecanismoControle;
  final List<ProdutorPropriedade> _propriedades;
  @override
  List<ProdutorPropriedade> get propriedades {
    if (_propriedades is EqualUnmodifiableListView) return _propriedades;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_propriedades);
  }

  @override
  String toString() {
    return 'Produtor(id: $id, nome: $nome, usuario: $usuario, mecanismoControle: $mecanismoControle, propriedades: $propriedades)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProdutorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.usuario, usuario) || other.usuario == usuario) &&
            (identical(other.mecanismoControle, mecanismoControle) ||
                other.mecanismoControle == mecanismoControle) &&
            const DeepCollectionEquality().equals(
              other._propriedades,
              _propriedades,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    usuario,
    mecanismoControle,
    const DeepCollectionEquality().hash(_propriedades),
  );

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProdutorImplCopyWith<_$ProdutorImpl> get copyWith =>
      __$$ProdutorImplCopyWithImpl<_$ProdutorImpl>(this, _$identity);
}

abstract class _Produtor implements Produtor {
  const factory _Produtor({
    required final int id,
    required final String nome,
    required final Usuario usuario,
    required final MecanismoControle? mecanismoControle,
    required final List<ProdutorPropriedade> propriedades,
  }) = _$ProdutorImpl;

  @override
  int get id;
  @override
  String get nome;
  @override
  Usuario get usuario;
  @override
  MecanismoControle? get mecanismoControle;
  @override
  List<ProdutorPropriedade> get propriedades;

  /// Create a copy of Produtor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProdutorImplCopyWith<_$ProdutorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
