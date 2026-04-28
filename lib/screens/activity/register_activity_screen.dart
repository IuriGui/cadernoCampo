import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/atividade_dao.dart';
import '../../core/dao/area_cultivo_dao.dart';
import '../../core/dao/cultura_dao.dart';
import '../../core/dao/insumo_dao.dart';
import '../../core/dao/registro_atividade_dao.dart';
import '../../core/models/atividade.dart';
import '../../core/models/area_cultivo.dart';
import '../../core/models/cultura.dart';
import '../../core/models/insumo.dart';
import '../../core/models/local.dart';
import '../../core/models/user.dart';
import '../../core/models/registro_atividade.dart';
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
  final _registroDAO = RegistroAtividadeDAO();
  
  final _obsController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _tempoController = TextEditingController();
  final _unidadeController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  
  int? _culturaId;
  int? _areaId;
  int? _atividadeId;
  int? _insumoId;

  List<Cultura> _culturas = [];
  List<AreaCultivo> _areas = [];
  List<Atividade> _atividades = [];
  List<Insumo> _insumos = [];
  
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _areaId = widget.preSelectedArea?.id;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final culturas = await CulturaDAO().getAll();
      final areas = await AreaCultivoDAO().getAreasByLocal(widget.local.id!);
      final atividades = await AtividadeDAO().getAll();
      final insumos = await InsumoDAO().getAll();

      setState(() {
        _culturas = culturas;
        _areas = areas;
        _atividades = atividades;
        _insumos = insumos;
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
      body: SingleChildScrollView(
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
                value: _culturaId,
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
                value: _areaId,
                decoration: InputDecoration(
                  labelText: 'Área de Cultivo',
                  prefixIcon: Icon(MdiIcons.mapMarkerRadius),
                ),
                items: _areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.titulo))).toList(),
                onChanged: (v) => setState(() => _areaId = v),
                validator: (v) => v == null ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown Atividade
              DropdownButtonFormField<int>(
                value: _atividadeId,
                decoration: InputDecoration(
                  labelText: 'Atividade',
                  prefixIcon: Icon(MdiIcons.tractor),
                ),
                items: _atividades.map((a) => DropdownMenuItem(value: a.id, child: Text(a.nome))).toList(),
                onChanged: (v) => setState(() => _atividadeId = v),
                validator: (v) => v == null ? '* Obrigatório' : null,
              ),
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
                onChanged: (v) => setState(() => _insumoId = v),
              ),
              
              if (_insumoId != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _quantidadeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Quantidade'),
                        validator: (v) => _insumoId != null && (v == null || v.isEmpty) ? '*' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _unidadeController,
                        decoration: const InputDecoration(labelText: 'Unidade (ex: kg, L, un)'),
                        validator: (v) => _insumoId != null && (v == null || v.isEmpty) ? '*' : null,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // Tempo Estimado
              TextFormField(
                controller: _tempoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tempo Estimado (minutos)',
                  prefixIcon: Icon(Icons.timer_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Responsável (Placeholder para o usuário logado)
              TextFormField(
                initialValue: widget.user.name,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Responsável',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Observações
              TextFormField(
                controller: _obsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  alignLabelWithHint: true,
                ),
              ),
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
        final registro = RegistroAtividade(
          dataOcorrencia: _dataSelecionada,
          areaCultivoId: _areaId!,
          atividadeId: _atividadeId!,
          culturaId: _culturaId,
          insumoId: _insumoId,
          quantidade: _insumoId != null ? int.tryParse(_quantidadeController.text) : null,
          unidadeInsumo: _insumoId != null ? _unidadeController.text : null,
          tempoEstimadoMin: int.tryParse(_tempoController.text),
          observacoes: _obsController.text,
          responsavelId: widget.user.id!,
        );

        await _registroDAO.insertRegistro(registro);

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
