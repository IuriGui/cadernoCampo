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

const _requerCultura = {'Plantio', 'Adubação', 'Colheita'};
const _requerInsumo  = {'Plantio', 'Adubação'};
const _requerDestino = {'Colheita'};

class RegisterActivityScreen extends StatefulWidget {
  final Local local;
  final User user;
  final AreaCultivo? preSelectedArea;

  const RegisterActivityScreen({
    super.key,
    required this.local,
    required this.user,
    this.preSelectedArea,
  });

  @override
  State<RegisterActivityScreen> createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _anotacaoDAO = AnotacaoDAO();

  final _quantidadeInsumoController = TextEditingController();
  final _unidadeInsumoController = TextEditingController();
  final _quantidadeColheitaController = TextEditingController();
  final _unidadeColheitaController = TextEditingController();
  final _destinoController = TextEditingController();

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

  // Regras de negócio
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
        appBar: AppBar(title: const Text('Registrar Atividade')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Atividade')),
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
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Salvar Registro',
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
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_today, color: Colors.green),
          title: const Text('Data da Ocorrência'),
          subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada)),
          onTap: _selecionarData,
          trailing: const Icon(Icons.edit, size: 20),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _areaId,
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
          initialValue: _atividadeId,
          decoration: InputDecoration(
            labelText: 'Atividade',
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
      initialValue: _culturaId,
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
        _buildSectionTitle('Destino'),
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
          'Unidade (ex: kg, un)',
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
        _buildSectionTitle('Insumos e Detalhes'),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _insumoId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Insumo Utilizado',
            prefixIcon: Icon(MdiIcons.packageVariantClosed),
          ),
          items: _insumos
              .map((i) => DropdownMenuItem(
            value: i.id,
            child: Text(
              '${i.produto} (${i.fornecedor} - ${DateFormat('dd/MM/yy').format(i.dataAquisicao)})',
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
            'Quantidade do Insumo',
            'Unidade (ex: L, kg)',
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
          flex: 3,
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
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1.1,
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
      );

      final destinoId = await _obterOuCriarDestinoId();
      await _anotacaoDAO.insertAnotacao(anotacao, destinoId: destinoId);

      _showSnackBar('Atividade registrada com sucesso!');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}