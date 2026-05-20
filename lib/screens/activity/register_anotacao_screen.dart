import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/atividade_dao.dart';
import '../../core/dao/area_cultivo_dao.dart';
import '../../core/dao/cultura_dao.dart';
import '../../core/dao/insumo_dao.dart';
import '../../core/dao/anotacao_dao.dart';
import '../../core/dao/destino_dao.dart';
import '../../core/models/atividade.dart';
import '../../core/models/area_cultivo.dart';
import '../../core/models/cultura.dart';
import '../../core/models/insumo.dart';
import '../../core/models/local.dart';
import '../../core/models/user.dart';
import '../../core/models/anotacao.dart';
import '../../core/models/destino.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

const _requerCultura = {'Plantio', 'Adubação', 'Colheita'};
const _requerInsumo  = {'Adubação'};
const _requerDestino = {'Colheita'};

class RegisterAnotacaoScreen extends StatefulWidget {
  final Local local;
  final User user;
  final AreaCultivo? preSelectedArea;

  const RegisterAnotacaoScreen({
    super.key,
    required this.local,
    required this.user,
    this.preSelectedArea,
  });

  @override
  State<RegisterAnotacaoScreen> createState() => _RegisterAnotacaoScreenState();
}

class _RegisterAnotacaoScreenState extends State<RegisterAnotacaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _anotacaoDAO = AnotacaoDAO();

  final _quantidadeInsumoController = TextEditingController();
  final _unidadeInsumoController = TextEditingController();
  final _quantidadeColheitaController = TextEditingController();
  final _unidadeColheitaController = TextEditingController();
  final _destinoController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();

  int? _culturaId;
  int? _areaId;
  int? _atividadeId;
  int? _insumoId;

  List<Cultura> _culturas = [];
  List<AreaCultivo> _areas = [];
  List<Atividade> _atividades = [];
  List<Insumo> _insumos = [];
  List<Destino> _destinos = [];

  bool _isLoading = true;
  bool _isSaving = false;

  String? get _nomeAtividade => _atividadeId == null
      ? null
      : _atividades.firstWhere((a) => a.id == _atividadeId).nome;

  bool get _exibeCultura => _nomeAtividade != null && _requerCultura.contains(_nomeAtividade);
  bool get _exibeInsumo  => _nomeAtividade != null && _requerInsumo.contains(_nomeAtividade);
  bool get _exibeDestino => _nomeAtividade != null && _requerDestino.contains(_nomeAtividade);

  @override
  void initState() {
    super.initState();
    _areaId = widget.preSelectedArea?.id;
    _loadData();
  }

  @override
  void dispose() {
    _quantidadeInsumoController.dispose();
    _unidadeInsumoController.dispose();
    _quantidadeColheitaController.dispose();
    _unidadeColheitaController.dispose();
    _destinoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await Future.wait([
        CulturaDAO().getAll(),
        AreaCultivoDAO().getAreasByLocal(widget.local.id!),
        AtividadeDAO().getAll(),
        InsumoDAO().getInsumosByPropriedade(widget.local.propriedadeId),
        DestinoDAO().getAllDestinos(),
      ]);

      setState(() {
        _culturas  = data[0] as List<Cultura>;
        _areas     = data[1] as List<AreaCultivo>;
        _atividades = data[2] as List<Atividade>;
        _insumos   = data[3] as List<Insumo>;
        _destinos  = data[4] as List<Destino>;
        _isLoading = false;
      });
    } catch (e) {
      _showSnackBar('Erro ao carregar dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registrar Anotação')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Anotação')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInfoSection(),
                if (_exibeCultura) ...[
                  const SizedBox(height: 16),
                  _buildCulturaField(),
                ],
                if (_exibeDestino) _buildColheitaSection(),
                if (_exibeInsumo) ...[
                  const SizedBox(height: 24),
                  _buildInsumosSection(),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observacoesController,
                  decoration: const InputDecoration(
                    labelText: 'Observações',
                    prefixIcon: Icon(Icons.notes),
                    hintText: 'Detalhes adicionais sobre a anotação...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Salvar Anotação',
                  isLoading: _isSaving,
                  onPressed: _salvarRegistro,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Informações Básicas'),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selecionarData,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppTheme.primaryGreen, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data da Ocorrência', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                const Icon(Icons.edit, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _areaId,
          decoration: InputDecoration(
            labelText: 'Área de Cultivo',
            prefixIcon: Icon(MdiIcons.mapMarkerRadius),
          ),
          items: _areas
              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome)))
              .toList(),
          onChanged: (v) => setState(() => _areaId = v),
          validator: (v) => v == null ? '* Obrigatório' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _atividadeId,
          decoration: InputDecoration(
            labelText: 'Tipo de Atividade',
            prefixIcon: Icon(MdiIcons.tractor),
          ),
          items: _atividades
              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome)))
              .toList(),
          onChanged: (v) {
            setState(() {
              _atividadeId = v;
              _culturaId = null;
              _insumoId = null;
              _quantidadeColheitaController.clear();
              _unidadeColheitaController.clear();
              _quantidadeInsumoController.clear();
              _unidadeInsumoController.clear();
              _destinoController.clear();
            });
          },
          validator: (v) => v == null ? '* Obrigatório' : null,
        ),
      ],
    );
  }

  Widget _buildCulturaField() {
    return DropdownButtonFormField<int>(
      value: _culturaId,
      decoration: InputDecoration(
        labelText: 'Cultura',
        prefixIcon: Icon(MdiIcons.sprout),
      ),
      items: _culturas
          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
          .toList(),
      onChanged: (v) => setState(() => _culturaId = v),
      validator: (v) => v == null ? '* Obrigatório' : null,
    );
  }

  Widget _buildColheitaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('Destino da Produção'),
        const SizedBox(height: 16),
        Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) return _destinos.map((d) => d.nome);
            return _destinos
                .map((d) => d.nome)
                .where((o) => o.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (selection) => _destinoController.text = selection,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            if (controller.text.isEmpty && _destinoController.text.isNotEmpty) {
              controller.text = _destinoController.text;
            }
            controller.addListener(() => _destinoController.text = controller.text);
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Título do Destino',
                prefixIcon: Icon(Icons.place_outlined),
                hintText: 'Ex: Mercado Central, Feira Local...',
              ),
              validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildQuantityUnitFields(
          'Quantidade Colhida',
          'Unid. (ex: kg)',
          _quantidadeColheitaController,
          _unidadeColheitaController,
        ),
      ],
    );
  }

  Widget _buildInsumosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Insumo Utilizado'),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _insumoId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Selecione o Insumo',
            prefixIcon: Icon(MdiIcons.packageVariantClosed),
          ),
          items: _insumos
              .map((i) => DropdownMenuItem(
            value: i.id,
            child: Text(
              '${i.produto} (${i.fornecedor})',
              overflow: TextOverflow.ellipsis,
            ),
          ))
              .toList(),
          onChanged: (v) => setState(() {
            _insumoId = v;
            if (v == null) {
              _quantidadeInsumoController.clear();
              _unidadeInsumoController.clear();
            }
          }),
          validator: (v) => v == null ? '* Obrigatório' : null,
        ),
        if (_insumoId != null) ...[
          const SizedBox(height: 16),
          _buildQuantityUnitFields(
            'Qtd. Utilizada',
            'Unid. (ex: L, kg)',
            _quantidadeInsumoController,
            _unidadeInsumoController,
          ),
        ],
      ],
    );
  }

  Widget _buildQuantityUnitFields(
      String qLabel,
      String uLabel,
      TextEditingController qController,
      TextEditingController uController,
      ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: qController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: qLabel),
            validator: (v) => v == null || v.isEmpty ? '*' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: uController,
            decoration: InputDecoration(labelText: uLabel),
            validator: (v) => v == null || v.isEmpty ? '*' : null,
          ),
        ),
      ],
    );
  }



  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    );
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() => _dataSelecionada = picked);
    }
  }

  Future<int?> _obterOuCriarDestinoId() async {
    if (!_exibeDestino) return null;
    final nome = _destinoController.text.trim();
    if (nome.isEmpty) return null;
    final dao = DestinoDAO();
    final destino = await dao.getDestinoByNome(nome);
    return destino?.id ?? await dao.insertDestino(Destino(nome: nome));
  }

  (double, String) _obterQuantidadeEUnidade() {
    if (_exibeDestino) {
      return (
      double.tryParse(_quantidadeColheitaController.text) ?? 0.0,
      _unidadeColheitaController.text,
      );
    } else if (_insumoId != null) {
      return (
      double.tryParse(_quantidadeInsumoController.text) ?? 0.0,
      _unidadeInsumoController.text,
      );
    }
    return (0.0, '');
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _salvarRegistro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final (quantidade, unidade) = _obterQuantidadeEUnidade();

      final anotacao = Anotacao(
        dataCriacao: _dataSelecionada,
        areaCultivoId: _areaId,
        atividadeId: _atividadeId!,
        culturaId: _culturaId,
        insumoId: _insumoId,
        quantidade: quantidade,
        unidadeMedida: unidade,
        observacao: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text,
      );

      final destinoId = await _obterOuCriarDestinoId();
      await _anotacaoDAO.insertAnotacao(anotacao, destinoId: destinoId);

      _showSnackBar('Anotação registrada com sucesso!');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}