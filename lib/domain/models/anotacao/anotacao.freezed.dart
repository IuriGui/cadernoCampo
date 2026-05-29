// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anotacao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Anotacao {
  int get id => throw _privateConstructorUsedError;
  DateTime get dataCriacao => throw _privateConstructorUsedError;
  Atividade get atividade => throw _privateConstructorUsedError;
  AreaCultivo? get areaCultivo => throw _privateConstructorUsedError;
  Insumo? get insumo => throw _privateConstructorUsedError;
  Cultura? get cultura =>
      throw _privateConstructorUsedError; // String? nomeDestino,
  double get quantidade => throw _privateConstructorUsedError;
  String? get unidadeMedida => throw _privateConstructorUsedError;
  String? get observacao => throw _privateConstructorUsedError;

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnotacaoCopyWith<Anotacao> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnotacaoCopyWith<$Res> {
  factory $AnotacaoCopyWith(Anotacao value, $Res Function(Anotacao) then) =
      _$AnotacaoCopyWithImpl<$Res, Anotacao>;
  @useResult
  $Res call({
    int id,
    DateTime dataCriacao,
    Atividade atividade,
    AreaCultivo? areaCultivo,
    Insumo? insumo,
    Cultura? cultura,
    double quantidade,
    String? unidadeMedida,
    String? observacao,
  });

  $AtividadeCopyWith<$Res> get atividade;
  $AreaCultivoCopyWith<$Res>? get areaCultivo;
  $InsumoCopyWith<$Res>? get insumo;
  $CulturaCopyWith<$Res>? get cultura;
}

/// @nodoc
class _$AnotacaoCopyWithImpl<$Res, $Val extends Anotacao>
    implements $AnotacaoCopyWith<$Res> {
  _$AnotacaoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataCriacao = null,
    Object? atividade = null,
    Object? areaCultivo = freezed,
    Object? insumo = freezed,
    Object? cultura = freezed,
    Object? quantidade = null,
    Object? unidadeMedida = freezed,
    Object? observacao = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            dataCriacao: null == dataCriacao
                ? _value.dataCriacao
                : dataCriacao // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            atividade: null == atividade
                ? _value.atividade
                : atividade // ignore: cast_nullable_to_non_nullable
                      as Atividade,
            areaCultivo: freezed == areaCultivo
                ? _value.areaCultivo
                : areaCultivo // ignore: cast_nullable_to_non_nullable
                      as AreaCultivo?,
            insumo: freezed == insumo
                ? _value.insumo
                : insumo // ignore: cast_nullable_to_non_nullable
                      as Insumo?,
            cultura: freezed == cultura
                ? _value.cultura
                : cultura // ignore: cast_nullable_to_non_nullable
                      as Cultura?,
            quantidade: null == quantidade
                ? _value.quantidade
                : quantidade // ignore: cast_nullable_to_non_nullable
                      as double,
            unidadeMedida: freezed == unidadeMedida
                ? _value.unidadeMedida
                : unidadeMedida // ignore: cast_nullable_to_non_nullable
                      as String?,
            observacao: freezed == observacao
                ? _value.observacao
                : observacao // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AtividadeCopyWith<$Res> get atividade {
    return $AtividadeCopyWith<$Res>(_value.atividade, (value) {
      return _then(_value.copyWith(atividade: value) as $Val);
    });
  }

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AreaCultivoCopyWith<$Res>? get areaCultivo {
    if (_value.areaCultivo == null) {
      return null;
    }

    return $AreaCultivoCopyWith<$Res>(_value.areaCultivo!, (value) {
      return _then(_value.copyWith(areaCultivo: value) as $Val);
    });
  }

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InsumoCopyWith<$Res>? get insumo {
    if (_value.insumo == null) {
      return null;
    }

    return $InsumoCopyWith<$Res>(_value.insumo!, (value) {
      return _then(_value.copyWith(insumo: value) as $Val);
    });
  }

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CulturaCopyWith<$Res>? get cultura {
    if (_value.cultura == null) {
      return null;
    }

    return $CulturaCopyWith<$Res>(_value.cultura!, (value) {
      return _then(_value.copyWith(cultura: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnotacaoImplCopyWith<$Res>
    implements $AnotacaoCopyWith<$Res> {
  factory _$$AnotacaoImplCopyWith(
    _$AnotacaoImpl value,
    $Res Function(_$AnotacaoImpl) then,
  ) = __$$AnotacaoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    DateTime dataCriacao,
    Atividade atividade,
    AreaCultivo? areaCultivo,
    Insumo? insumo,
    Cultura? cultura,
    double quantidade,
    String? unidadeMedida,
    String? observacao,
  });

  @override
  $AtividadeCopyWith<$Res> get atividade;
  @override
  $AreaCultivoCopyWith<$Res>? get areaCultivo;
  @override
  $InsumoCopyWith<$Res>? get insumo;
  @override
  $CulturaCopyWith<$Res>? get cultura;
}

/// @nodoc
class __$$AnotacaoImplCopyWithImpl<$Res>
    extends _$AnotacaoCopyWithImpl<$Res, _$AnotacaoImpl>
    implements _$$AnotacaoImplCopyWith<$Res> {
  __$$AnotacaoImplCopyWithImpl(
    _$AnotacaoImpl _value,
    $Res Function(_$AnotacaoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataCriacao = null,
    Object? atividade = null,
    Object? areaCultivo = freezed,
    Object? insumo = freezed,
    Object? cultura = freezed,
    Object? quantidade = null,
    Object? unidadeMedida = freezed,
    Object? observacao = freezed,
  }) {
    return _then(
      _$AnotacaoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        dataCriacao: null == dataCriacao
            ? _value.dataCriacao
            : dataCriacao // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        atividade: null == atividade
            ? _value.atividade
            : atividade // ignore: cast_nullable_to_non_nullable
                  as Atividade,
        areaCultivo: freezed == areaCultivo
            ? _value.areaCultivo
            : areaCultivo // ignore: cast_nullable_to_non_nullable
                  as AreaCultivo?,
        insumo: freezed == insumo
            ? _value.insumo
            : insumo // ignore: cast_nullable_to_non_nullable
                  as Insumo?,
        cultura: freezed == cultura
            ? _value.cultura
            : cultura // ignore: cast_nullable_to_non_nullable
                  as Cultura?,
        quantidade: null == quantidade
            ? _value.quantidade
            : quantidade // ignore: cast_nullable_to_non_nullable
                  as double,
        unidadeMedida: freezed == unidadeMedida
            ? _value.unidadeMedida
            : unidadeMedida // ignore: cast_nullable_to_non_nullable
                  as String?,
        observacao: freezed == observacao
            ? _value.observacao
            : observacao // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AnotacaoImpl implements _Anotacao {
  const _$AnotacaoImpl({
    required this.id,
    required this.dataCriacao,
    required this.atividade,
    this.areaCultivo,
    this.insumo,
    this.cultura,
    required this.quantidade,
    this.unidadeMedida,
    this.observacao,
  });

  @override
  final int id;
  @override
  final DateTime dataCriacao;
  @override
  final Atividade atividade;
  @override
  final AreaCultivo? areaCultivo;
  @override
  final Insumo? insumo;
  @override
  final Cultura? cultura;
  // String? nomeDestino,
  @override
  final double quantidade;
  @override
  final String? unidadeMedida;
  @override
  final String? observacao;

  @override
  String toString() {
    return 'Anotacao(id: $id, dataCriacao: $dataCriacao, atividade: $atividade, areaCultivo: $areaCultivo, insumo: $insumo, cultura: $cultura, quantidade: $quantidade, unidadeMedida: $unidadeMedida, observacao: $observacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnotacaoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao) &&
            (identical(other.atividade, atividade) ||
                other.atividade == atividade) &&
            (identical(other.areaCultivo, areaCultivo) ||
                other.areaCultivo == areaCultivo) &&
            (identical(other.insumo, insumo) || other.insumo == insumo) &&
            (identical(other.cultura, cultura) || other.cultura == cultura) &&
            (identical(other.quantidade, quantidade) ||
                other.quantidade == quantidade) &&
            (identical(other.unidadeMedida, unidadeMedida) ||
                other.unidadeMedida == unidadeMedida) &&
            (identical(other.observacao, observacao) ||
                other.observacao == observacao));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dataCriacao,
    atividade,
    areaCultivo,
    insumo,
    cultura,
    quantidade,
    unidadeMedida,
    observacao,
  );

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnotacaoImplCopyWith<_$AnotacaoImpl> get copyWith =>
      __$$AnotacaoImplCopyWithImpl<_$AnotacaoImpl>(this, _$identity);
}

abstract class _Anotacao implements Anotacao {
  const factory _Anotacao({
    required final int id,
    required final DateTime dataCriacao,
    required final Atividade atividade,
    final AreaCultivo? areaCultivo,
    final Insumo? insumo,
    final Cultura? cultura,
    required final double quantidade,
    final String? unidadeMedida,
    final String? observacao,
  }) = _$AnotacaoImpl;

  @override
  int get id;
  @override
  DateTime get dataCriacao;
  @override
  Atividade get atividade;
  @override
  AreaCultivo? get areaCultivo;
  @override
  Insumo? get insumo;
  @override
  Cultura? get cultura; // String? nomeDestino,
  @override
  double get quantidade;
  @override
  String? get unidadeMedida;
  @override
  String? get observacao;

  /// Create a copy of Anotacao
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnotacaoImplCopyWith<_$AnotacaoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
