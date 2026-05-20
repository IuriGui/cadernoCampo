import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/anotacao_dao.dart';
import '../../core/dao/atividade_dao.dart';
import '../../core/models/anotacao.dart';
import '../../core/models/atividade.dart';
import '../../core/models/user.dart';
import '../../core/models/propriedade.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/anotacao_card.dart';
import 'anotacoes_detail_screen.dart';
import '../localAndAreaCultivo/local_screen.dart';

class AnotacoesListScreen extends StatefulWidget {
  final User user;
  final Propriedade propriedade;
  const AnotacoesListScreen({super.key, required this.user, required this.propriedade});

  @override
  State<AnotacoesListScreen> createState() => _AnotacoesListScreenState();
}

class _AnotacoesListScreenState extends State<AnotacoesListScreen> {
  final AnotacaoDAO _dao = AnotacaoDAO();
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
      _dao.getAnotacoesByPropriedade(widget.propriedade.id!),
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
        // Filtro por Atividade
        bool matchesAtividade = _selectedAtividadeIds.isEmpty || 
                               _selectedAtividadeIds.contains(r.atividadeId);
        
        // Filtro por Data
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
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
              title: const Text('Filtrar por Atividades'),
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
                  child: const Text('Limpar Tudo', style: TextStyle(color: Colors.red)),
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
      appBar: AppBar(
        title: const Text('Anotações do Campo'),
        actions: [
          IconButton(
            icon: Icon(_selectedDateRange != null ? Icons.calendar_month : Icons.calendar_today_outlined),
            color: _selectedDateRange != null ? Colors.white : null,
            tooltip: 'Filtrar por Data',
            onPressed: _pickDateRange,
          ),
          IconButton(
            icon: Icon(_selectedAtividadeIds.isNotEmpty ? Icons.filter_alt : Icons.filter_alt_outlined),
            color: _selectedAtividadeIds.isNotEmpty ? Colors.white : null,
            tooltip: 'Filtrar por Atividade',
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: _selectedAtividadeIds.isEmpty && _selectedDateRange == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      if (_selectedDateRange != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text(
                              '${DateFormat('dd/MM').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM').format(_selectedDateRange!.end)}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedDateRange = null;
                                _applyFilters();
                              });
                            },
                            deleteIcon: const Icon(Icons.close, size: 14),
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
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedAtividadeIds.remove(a.id);
                                _applyFilters();
                              });
                            },
                            deleteIcon: const Icon(Icons.close, size: 14),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: AppTheme.primaryGreen),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _filteredRegistros.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(MdiIcons.clipboardOffOutline, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma anotação encontrada com os filtros atuais.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
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
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredRegistros.length,
              itemBuilder: (context, index) {
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
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocalScreen(
                user: widget.user,
                propriedade: widget.propriedade,
                selectionMode: true,
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
