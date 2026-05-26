import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../data/dao/anotacao_dao.dart';
import '../../../data/dao/atividade_dao.dart';
import '../../../data/models/area_cultivo.dart';
import '../../../data/models/anotacao.dart';
import '../../../data/models/atividade.dart';
import '../../../data/models/user.dart';
import '../../../data/models/local.dart';
import '../../theme/app_theme.dart';
import '../../widgets/anotacao_card.dart';
import '../activity/register_anotacao_screen.dart';
import '../activity/anotacoes_detail_screen.dart';

class AreaDetailScreen extends StatefulWidget {
  final AreaCultivo area;
  final Local local;
  final User user;

  const AreaDetailScreen({
    super.key,
    required this.area,
    required this.local,
    required this.user,
  });

  @override
  State<AreaDetailScreen> createState() => _AreaDetailScreenState();
}

class _AreaDetailScreenState extends State<AreaDetailScreen> {
  final AnotacaoDAO _anotacaoDAO = AnotacaoDAO();
  final AtividadeDAO _atividadeDAO = AtividadeDAO();
  
  List<Anotacao> _allRegistros = [];
  List<Anotacao> _filteredRegistros = [];
  List<Atividade> _allAtividades = [];
  
  Set<int> _selectedAtividadeIds = {};
  DateTimeRange? _selectedDateRange;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _anotacaoDAO.getAnotacoesByArea(widget.area.id!),
      _atividadeDAO.getAll(),
    ]);
    
    setState(() {
      _allRegistros = results[0] as List<Anotacao>;
      _allAtividades = results[1] as List<Atividade>;
      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredRegistros = _allRegistros.where((r) {
        bool matchesAtividade = _selectedAtividadeIds.isEmpty || 
                               _selectedAtividadeIds.contains(r.atividadeId);
        
        bool matchesDate = true;
        if (_selectedDateRange != null) {
          final date = DateTime(r.dataCriacao.year, r.dataCriacao.month, r.dataCriacao.day);
          final start = DateTime(_selectedDateRange!.start.year, _selectedDateRange!.start.month, _selectedDateRange!.start.day);
          final end = DateTime(_selectedDateRange!.end.year, _selectedDateRange!.end.month, _selectedDateRange!.end.day);
          matchesDate = (date.isAtSameMomentAs(start) || date.isAfter(start)) && 
                        (date.isAtSameMomentAs(end) || date.isBefore(end));
        }
        
        return matchesAtividade && matchesDate;
      }).toList();
    });
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _applyFilters();
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filtrar Atividades'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allAtividades.length,
                  itemBuilder: (context, index) {
                    final a = _allAtividades[index];
                    final isSelected = _selectedAtividadeIds.contains(a.id);
                    return CheckboxListTile(
                      title: Text(a.nome),
                      value: isSelected,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (v) {
                        setDialogState(() {
                          if (v == true) {
                            _selectedAtividadeIds.add(a.id!);
                          } else {
                            _selectedAtividadeIds.remove(a.id);
                          }
                        });
                        setState(() => _applyFilters());
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedAtividadeIds.clear();
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Limpar', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(_selectedDateRange != null ? Icons.calendar_month : Icons.calendar_today_outlined),
                tooltip: 'Filtrar Data',
                onPressed: _pickDateRange,
              ),
              IconButton(
                icon: Icon(_selectedAtividadeIds.isNotEmpty ? Icons.filter_alt : Icons.filter_alt_outlined),
                tooltip: 'Filtrar Atividade',
                onPressed: _showFilterDialog,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.area.nome,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white),
              ),
              centerTitle: true,
              background: Container(

                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [AppTheme.primaryGreen, AppTheme.primaryGreen.withValues(alpha: 0.8)],
                //   ),
                // ),
                child: Center(
                  child: Icon(
                    MdiIcons.sprout,
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),

          // ── Active Filters Bar ──
          if (_selectedAtividadeIds.isNotEmpty || _selectedDateRange != null)
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    if (_selectedDateRange != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            '${DateFormat('dd/MM').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM').format(_selectedDateRange!.end)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedDateRange = null;
                              _applyFilters();
                            });
                          },
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppTheme.primaryGreen),
                        ),
                      ),
                    ..._allAtividades.where((a) => _selectedAtividadeIds.contains(a.id)).map((a) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            a.nome,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedAtividadeIds.remove(a.id);
                              _applyFilters();
                            });
                          },
                          backgroundColor: Colors.white,
                          side: BorderSide(color: AppTheme.primaryGreen),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'HISTÓRICO DE ANOTAÇÕES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // ── List ──
          _isLoading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : _filteredRegistros.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.clipboardOffOutline, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              'Nenhuma anotação encontrada.',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            if (_selectedAtividadeIds.isNotEmpty || _selectedDateRange != null)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedAtividadeIds.clear();
                                    _selectedDateRange = null;
                                    _applyFilters();
                                  });
                                },
                                child: const Text('Limpar filtros'),
                              ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final registro = _filteredRegistros[index];
                            return AnotacaoCard(
                              registro: registro,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnotacoesDetailScreen(registro: registro),
                                  ),
                                );
                                if (result == true) _loadInitialData();
                              },
                            );
                          },
                          childCount: _filteredRegistros.length,
                        ),
                      ),
                    ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterAnotacaoScreen(
                local: widget.local,
                user: widget.user,
                preSelectedArea: widget.area,
              ),
            ),
          );
          if (result == true) _loadInitialData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Anotação'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
}
