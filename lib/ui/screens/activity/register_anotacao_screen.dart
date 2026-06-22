import 'package:caderno_de_campo/data/dao/produtor_dao.dart';
import 'package:caderno_de_campo/data/models/canal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../data/dao/atividade_dao.dart';
import '../../../data/dao/area_cultivo_dao.dart';
import '../../../data/dao/canal_escoamento_dao.dart';
import '../../../data/dao/cultura_dao.dart';
import '../../../data/dao/insumo_dao.dart';
import '../../../data/dao/anotacao_dao.dart';
import '../../../data/dao/propriedade_dao.dart';
import '../../../data/models/atividade.dart';
import '../../../data/models/area_cultivo.dart';
import '../../../data/models/cultura.dart';
import '../../../data/models/insumo.dart';
import '../../../data/models/local.dart';
import '../../../data/models/produtor.dart';
import '../../../data/models/user.dart';
import '../../../data/models/anotacao.dart';
import '../../../data/models/propriedade.dart';
import '../../widgets/primary_button.dart';
import '../supply/register_insumo_screen.dart';
import '../../theme/app_theme.dart';

const _requerCultura = {'Plantio', 'Adubação', 'Colheita'};
const _requerInsumo  = {
  'Adubação',
  'Preparo do solo',
  'Plantio',
  'Cobertura do solo',
};
const _requerCanalEscoamento = {'Destinar colheita'};
const _requerQuantidade = {'Colheita'};

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
  final _quantidadePlantioController = TextEditingController();
  final _unidadePlantioController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();

  int? _culturaId;
  int? _areaId;
  int? _atividadeId;
  int? _insumoId;
  int? _canalId;
  int? _colheitaId;


  List<Cultura> _culturas = [];
  List<AreaCultivo> _areas = [];
  List<Atividade> _atividades = [];
  List<Insumo> _insumos = [];
  List<CanalEscoamento> _canais = [];
  Propriedade? _propriedade;
  List<Map<String, dynamic>> _colheitas = [];


  bool _isLoading = true;
  bool _isSaving = false;

  String? get _nomeAtividade => _atividadeId == null
      ? null
      : _atividades.firstWhere((a) => a.id == _atividadeId).nome;

  bool get _exibeCultura => _nomeAtividade != null && _requerCultura.contains(_nomeAtividade);
  bool get _exibeInsumo  => _nomeAtividade != null && _requerInsumo.contains(_nomeAtividade);
  bool get _exibeCanalEscoamento => _nomeAtividade != null && _requerCanalEscoamento.contains(_nomeAtividade);
  bool get _exibeQuantidade => _nomeAtividade != null && _requerQuantidade.contains(_nomeAtividade);

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
    _quantidadePlantioController.dispose();
    _unidadePlantioController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      Produtor? p = await ProdutorDAO().getProdutorByUsuario(widget.user.id!);
      if (p != null) {
        _canais = await CanalEscoamentoDAO().getCanaisByProdutor(p.id!);
      }

      final data = await Future.wait([
        CulturaDAO().getAll(),
        AreaCultivoDAO().getAreasByLocal(widget.local.id!),
        AtividadeDAO().getAll(),
        InsumoDAO().getInsumosByPropriedade(widget.local.propriedadeId),
        PropriedadeDAO().getPropriedadeById(widget.local.propriedadeId),
      ]);

      final colheitas = await AnotacaoDAO().getColheitasByLocal(widget.local.id!);


      setState(() {
        _colheitas = colheitas;
        _culturas  = data[0] as List<Cultura>;
        _areas     = data[1] as List<AreaCultivo>;
        _atividades = data[2] as List<Atividade>;
        _insumos   = data[3] as List<Insumo>;
        _propriedade = data[4] as Propriedade?;
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
                  _buildPlantioSection(),
                ],
                if (_exibeCanalEscoamento) _buildColheitaSection(),
                if (_exibeInsumo) ...[
                  const SizedBox(height: 24),
                  _buildInsumosSection(),
                ],
                if (_exibeQuantidade) ...[
                  const SizedBox(height: 24),
                  _buildQuantidadeColheitaSection(),
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
              _canalId = null;
              _quantidadeColheitaController.clear();
              _unidadeColheitaController.clear();
              _quantidadeInsumoController.clear();
              _unidadeInsumoController.clear();
              _quantidadePlantioController.clear();
              _unidadePlantioController.clear();
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
      onChanged: (v) => setState(() {
        _culturaId = v;
        _quantidadePlantioController.clear();
        _unidadePlantioController.clear();
      }),
      validator: (v) => v == null ? '* Obrigatório' : null,
    );
  }

  Widget _buildPlantioSection() {
    if (_nomeAtividade != 'Plantio' || _culturaId == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        _buildQuantityUnitFields(
          'Quantidade Plantada',
          'Unid. (ex: mudas, kg)',
          _quantidadePlantioController,
          _unidadePlantioController,
        ),
      ],
    );
  }

  Widget _buildColheitaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        _buildSectionTitle('Escoamento da Produção'),
        const SizedBox(height: 16),
        _buildColheitaDropdown(),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _canalId,
          decoration: InputDecoration(
            labelText: 'Canal de Escoamento',
            prefixIcon: Icon(MdiIcons.truckDelivery),
          ),
          items: _canais
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome)))
              .toList(),
          onChanged: (v) => setState(() => _canalId = v),
          validator: (v) => v == null ? '* Obrigatório' : null,
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
          initialValue: _insumoId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Selecione o Insumo',
            prefixIcon: Icon(MdiIcons.packageVariantClosed),
          ),
          items: [
            ..._insumos.map((i) => DropdownMenuItem(
              value: i.id,
              child: Text(
                '${i.produto} (${i.fornecedor})',
                overflow: TextOverflow.ellipsis,
              ),
            )),
            const DropdownMenuItem<int>(
              value: -1,
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: AppTheme.primaryGreen, size: 20),
                  SizedBox(width: 8),
                  Text('Cadastrar Novo...', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          onChanged: (v) {
            if (v == -1) {
              _navToRegisterInsumo();
            } else {
              setState(() {
                _insumoId = v;
                if (v == null) {
                  _quantidadeInsumoController.clear();
                  _unidadeInsumoController.clear();
                }
              });
            }
          },
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
            validator: (v) {
              if (v == null || v.isEmpty) return '* Obrigatório';
              final n = double.tryParse(v.replaceAll(',', '.'));
              if (n == null) return 'Valor inválido';
              if (n <= 0) return 'Deve ser maior que zero';
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: uController,
            decoration: InputDecoration(labelText: uLabel),
            // TODO MONTAR O CAMPINHO DE CULTURA E UNIDADE
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

  Future<void> _navToRegisterInsumo() async {
    if (_propriedade == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterInsumoScreen(propriedade: _propriedade!),
      ),
    );

    if (result is Insumo) {
      setState(() {
        _insumos.add(result);
        _insumoId = result.id;
      });
    }
  }

  (double, String) _obterQuantidadeEUnidade() {
    if (_exibeCanalEscoamento || _exibeQuantidade) {
      return (
      double.tryParse(_quantidadeColheitaController.text) ?? 0.0,
      _unidadeColheitaController.text,
      );
    } else if (_nomeAtividade == 'Plantio' && _culturaId != null) {
      return (
      double.tryParse(_quantidadePlantioController.text) ?? 0.0,
      _unidadePlantioController.text,
      );
    } else if (_insumoId != null) {
      return (
      double.tryParse(_quantidadeInsumoController.text) ?? 0.0,
      _unidadeInsumoController.text,
      );
    }
    return (0.0, '');
  }

  Widget _buildQuantidadeColheitaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Quantidade Colhida'),
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

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _buildColheitaDropdown() {
    return DropdownButtonFormField<int>(
      initialValue: _colheitaId,
      decoration: InputDecoration(
        labelText: 'Colheita',
        prefixIcon: Icon(MdiIcons.barley),
      ),
      items: _colheitas.map((c) {
        final data = DateFormat('dd/MM/yyyy').format(
          DateTime.parse(c['data_criacao']),
        );
        final cultura = c['cultura'] ?? 'Sem cultura';
        return DropdownMenuItem<int>(
          value: c['id'] as int,
          child: Text('$cultura — $data'),
        );
      }).toList(),
      onChanged: (v) => setState(() => _colheitaId = v),
      validator: (v) => v == null ? '* Obrigatório' : null,
    );
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


      if(_nomeAtividade == 'Colheita') {
        await _anotacaoDAO.insertAnotacao(
          anotacao,
          isColheita: true,
        );
      } else if(_nomeAtividade == 'Destinar colheita'){
        await _anotacaoDAO.insertAnotacao(
          anotacao,
          colheitaId: _colheitaId,
          canalEscoamentoId: _canalId,
        );
      } else {
        await _anotacaoDAO.insertAnotacao(
          anotacao,
        );
      }




      _showSnackBar('Anotação registrada com sucesso!');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}