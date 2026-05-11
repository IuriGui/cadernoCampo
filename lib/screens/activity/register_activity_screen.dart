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

  bool get _isColheita {
    if (_atividadeId == null) return false;
    final atividade = _atividades.firstWhere((a) => a.id == _atividadeId);
    return atividade.nome.toLowerCase().contains('colheita');
  }

  bool get _hasInsumo => _insumoId != null;

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
      final culturas = await CulturaDAO().getAll();
      final areas = await AreaCultivoDAO().getAreasByLocal(widget.local.id!);
      final atividades = await AtividadeDAO().getAll();
      final insumos = await InsumoDAO().getInsumosByPropriedade(widget.local.propriedadeId);
      final destinos = await DestinoDAO().getAllDestinos();

      setState(() {
        _culturas = culturas;
        _areas = areas;
        _atividades = atividades;
        _insumos = insumos;
        _destinos = destinos;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
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
                _buildSectionTitle('Informações Básicas'),
                const SizedBox(height: 16),
                
                // Data da Atividade
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: Colors.green),
                  title: const Text('Data da Ocorrência'),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataSelecionada)),
                  onTap: _selecionarData,
                  trailing: const Icon(Icons.edit, size: 20),
                ),
                const SizedBox(height: 16),

                // Dropdown Cultura
                DropdownButtonFormField<int>(
                  initialValue: _culturaId,
                  decoration: InputDecoration(
                    labelText: 'Cultura',
                    prefixIcon: Icon(MdiIcons.sprout),
                  ),
                  items: _culturas.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nome))).toList(),
                  onChanged: (v) => setState(() => _culturaId = v),
                  validator: (v) => v == null ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown Área de Cultivo
                DropdownButtonFormField<int>(
                  initialValue: _areaId,
                  decoration: InputDecoration(
                    labelText: 'Área de Cultivo',
                    prefixIcon: Icon(MdiIcons.mapMarkerRadius),
                  ),
                  items: _areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome))).toList(),
                  onChanged: (v) => setState(() => _areaId = v),
                  validator: (v) => v == null ? '* Obrigatório' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown Atividade
                DropdownButtonFormField<int>(
                  initialValue: _atividadeId,
                  decoration: InputDecoration(
                    labelText: 'Atividade',
                    prefixIcon: Icon(MdiIcons.tractor),
                  ),
                  items: _atividades.map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome))).toList(),
                  onChanged: (v) => setState(() {
                    _atividadeId = v;
                    if (!_isColheita) {
                      _quantidadeColheitaController.clear();
                      _unidadeColheitaController.clear();
                      _destinoController.clear();
                    }
                  }),
                  validator: (v) => v == null ? '* Obrigatório' : null,
                ),

                if (_isColheita) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Destino'),
                  const SizedBox(height: 16),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return _destinos.map((d) => d.nome);
                      }
                      return _destinos
                          .map((d) => d.nome)
                          .where((String option) {
                        return option
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      _destinoController.text = selection;
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      // Sincroniza o controller do Autocomplete com o nosso _destinoController
                      if (controller.text.isEmpty && _destinoController.text.isNotEmpty) {
                        controller.text = _destinoController.text;
                      }
                      controller.addListener(() {
                        _destinoController.text = controller.text;
                      });
                      
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
                    true,
                  ),
                ],

                const SizedBox(height: 24),
                _buildSectionTitle('Insumos e Detalhes'),
                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  initialValue: _insumoId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Insumo Utilizado (Opcional)',
                    prefixIcon: Icon(MdiIcons.packageVariantClosed),
                  ),
                  items: [
                    const DropdownMenuItem<int>(value: null, child: Text('Nenhum')),
                    ..._insumos.map((i) => DropdownMenuItem(
                      value: i.id, 
                      child: Text("${i.produto} (${i.fornecedor} - ${DateFormat('dd/MM/yy').format(i.dataAquisicao)})")
                    )),
                  ],
                  onChanged: (v) => setState(() {
                    _insumoId = v;
                    if (v == null) {
                      _quantidadeInsumoController.clear();
                      _unidadeInsumoController.clear();
                    }
                  }),
                ),
                
                if (_hasInsumo) ...[
                  const SizedBox(height: 16),
                  _buildQuantityUnitFields(
                    'Quantidade do Insumo',
                    'Unidade (ex: L, kg)',
                    _quantidadeInsumoController,
                    _unidadeInsumoController,
                    true,
                  ),
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

  Widget _buildQuantityUnitFields(
    String qLabel, 
    String uLabel, 
    TextEditingController qController, 
    TextEditingController uController,
    bool isRequired,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: qController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: qLabel),
            validator: (v) => isRequired && (v == null || v.isEmpty) ? '*' : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: uController,
            decoration: InputDecoration(labelText: uLabel),
            validator: (v) => isRequired && (v == null || v.isEmpty) ? '*' : null,
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  void _salvarRegistro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        // Lógica de priorização: Se for colheita, salva os dados de colheita.
        // Se houver insumo, salva os dados do insumo.
        // O banco de dados no modelo Anotacao tem apenas uma dupla de qtd/unidade.
        double finalQtd = 0.0;
        String finalUnidade = '';

        if (_isColheita) {
          finalQtd = double.tryParse(_quantidadeColheitaController.text) ?? 0.0;
          finalUnidade = _unidadeColheitaController.text;
        } else if (_hasInsumo) {
          finalQtd = double.tryParse(_quantidadeInsumoController.text) ?? 0.0;
          finalUnidade = _unidadeInsumoController.text;
        }

        final anotacao = Anotacao(
          dataCriacao: _dataSelecionada,
          areaCultivoId: _areaId,
          atividadeId: _atividadeId!,
          culturaId: _culturaId,
          insumoId: _insumoId,
          quantidade: finalQtd,
          unidadeMedida: finalUnidade,
        );

        int? destinoId;
        if (_isColheita) {
          final destinoNome = _destinoController.text.trim();
          final destinoDAO = DestinoDAO();
          var destino = await destinoDAO.getDestinoByNome(destinoNome);
          if (destino == null) {
            destinoId = await destinoDAO.insertDestino(Destino(nome: destinoNome));
          } else {
            destinoId = destino.id;
          }
        }

        await _anotacaoDAO.insertAnotacao(anotacao, destinoId: destinoId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Atividade registrada com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
}
