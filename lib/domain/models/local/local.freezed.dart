// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Local {
  int? get id => throw _privateConstructorUsedError;
  String get nome =>
      throw _privateConstructorUsedError; // TODO Definir tipos de locais
  String get tipo => throw _privateConstructorUsedError;
  double get areaEmMetros => throw _privateConstructorUsedError;
  bool get quebraVento => throw _privateConstructorUsedError;
  bool get areaSensivel => throw _privateConstructorUsedError;
  String? get observacoes => throw _privateConstructorUsedError;
  Propriedade? get propriedade => throw _privateConstructorUsedError;

  /// Create a copy of Local
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalCopyWith<Local> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalCopyWith<$Res> {
  factory $LocalCopyWith(Local value, $Res Function(Local) then) =
      _$LocalCopyWithImpl<$Res, Local>;
  @useResult
  $Res call({
    int? id,
    String nome,
    String tipo,
    double areaEmMetros,
    bool quebraVento,
    bool areaSensivel,
    String? observacoes,
    Propriedade? propriedade,
  });

  $PropriedadeCopyWith<$Res>? get propriedade;
}

/// @nodoc
class _$LocalCopyWithImpl<$Res, $Val extends Local>
    implements $LocalCopyWith<$Res> {
  _$LocalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Local
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nome = null,
    Object? tipo = null,
    Object? areaEmMetros = null,
    Object? quebraVento = null,
    Object? areaSensivel = null,
    Object? observacoes = freezed,
    Object? propriedade = freezed,
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
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
            areaEmMetros: null == areaEmMetros
                ? _value.areaEmMetros
                : areaEmMetros // ignore: cast_nullable_to_non_nullable
                      as double,
            quebraVento: null == quebraVento
                ? _value.quebraVento
                : quebraVento // ignore: cast_nullable_to_non_nullable
                      as bool,
            areaSensivel: null == areaSensivel
                ? _value.areaSensivel
                : areaSensivel // ignore: cast_nullable_to_non_nullable
                      as bool,
            observacoes: freezed == observacoes
                ? _value.observacoes
                : observacoes // ignore: cast_nullable_to_non_nullable
                      as String?,
            propriedade: freezed == propriedade
                ? _value.propriedade
                : propriedade // ignore: cast_nullable_to_non_nullable
                      as Propriedade?,
          )
          as $Val,
    );
  }

  /// Create a copy of Local
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PropriedadeCopyWith<$Res>? get propriedade {
    if (_value.propriedade == null) {
      return null;
    }

    return $PropriedadeCopyWith<$Res>(_value.propriedade!, (value) {
      return _then(_value.copyWith(propriedade: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$localImplCopyWith<$Res> implements $LocalCopyWith<$Res> {
  factory _$$localImplCopyWith(
    _$localImpl value,
    $Res Function(_$localImpl) then,
  ) = __$$localImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String nome,
    String tipo,
    double areaEmMetros,
    bool quebraVento,
    bool areaSensivel,
    String? observacoes,
    Propriedade? propriedade,
  });

  @override
  $PropriedadeCopyWith<$Res>? get propriedade;
}

/// @nodoc
class __$$localImplCopyWithImpl<$Res>
    extends _$LocalCopyWithImpl<$Res, _$localImpl>
    implements _$$localImplCopyWith<$Res> {
  __$$localImplCopyWithImpl(
    _$localImpl _value,
    $Res Function(_$localImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Local
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nome = null,
    Object? tipo = null,
    Object? areaEmMetros = null,
    Object? quebraVento = null,
    Object? areaSensivel = null,
    Object? observacoes = freezed,
    Object? propriedade = freezed,
  }) {
    return _then(
      _$localImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
        areaEmMetros: null == areaEmMetros
            ? _value.areaEmMetros
            : areaEmMetros // ignore: cast_nullable_to_non_nullable
                  as double,
        quebraVento: null == quebraVento
            ? _value.quebraVento
            : quebraVento // ignore: cast_nullable_to_non_nullable
                  as bool,
        areaSensivel: null == areaSensivel
            ? _value.areaSensivel
            : areaSensivel // ignore: cast_nullable_to_non_nullable
                  as bool,
        observacoes: freezed == observacoes
            ? _value.observacoes
            : observacoes // ignore: cast_nullable_to_non_nullable
                  as String?,
        propriedade: freezed == propriedade
            ? _value.propriedade
            : propriedade // ignore: cast_nullable_to_non_nullable
                  as Propriedade?,
      ),
    );
  }
}

/// @nodoc

class _$localImpl implements _local {
  const _$localImpl({
    this.id,
    required this.nome,
    required this.tipo,
    required this.areaEmMetros,
    required this.quebraVento,
    required this.areaSensivel,
    this.observacoes,
    required this.propriedade,
  });

  @override
  final int? id;
  @override
  final String nome;
  // TODO Definir tipos de locais
  @override
  final String tipo;
  @override
  final double areaEmMetros;
  @override
  final bool quebraVento;
  @override
  final bool areaSensivel;
  @override
  final String? observacoes;
  @override
  final Propriedade? propriedade;

  @override
  String toString() {
    return 'Local(id: $id, nome: $nome, tipo: $tipo, areaEmMetros: $areaEmMetros, quebraVento: $quebraVento, areaSensivel: $areaSensivel, observacoes: $observacoes, propriedade: $propriedade)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$localImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.areaEmMetros, areaEmMetros) ||
                other.areaEmMetros == areaEmMetros) &&
            (identical(other.quebraVento, quebraVento) ||
                other.quebraVento == quebraVento) &&
            (identical(other.areaSensivel, areaSensivel) ||
                other.areaSensivel == areaSensivel) &&
            (identical(other.observacoes, observacoes) ||
                other.observacoes == observacoes) &&
            (identical(other.propriedade, propriedade) ||
                other.propriedade == propriedade));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    tipo,
    areaEmMetros,
    quebraVento,
    areaSensivel,
    observacoes,
    propriedade,
  );

  /// Create a copy of Local
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$localImplCopyWith<_$localImpl> get copyWith =>
      __$$localImplCopyWithImpl<_$localImpl>(this, _$identity);
}

abstract class _local implements Local {
  const factory _local({
    final int? id,
    required final String nome,
    required final String tipo,
    required final double areaEmMetros,
    required final bool quebraVento,
    required final bool areaSensivel,
    final String? observacoes,
    required final Propriedade? propriedade,
  }) = _$localImpl;

  @override
  int? get id;
  @override
  String get nome; // TODO Definir tipos de locais
  @override
  String get tipo;
  @override
  double get areaEmMetros;
  @override
  bool get quebraVento;
  @override
  bool get areaSensivel;
  @override
  String? get observacoes;
  @override
  Propriedade? get propriedade;

  /// Create a copy of Local
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$localImplCopyWith<_$localImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
