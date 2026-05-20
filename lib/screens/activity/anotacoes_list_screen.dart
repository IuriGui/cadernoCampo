import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/anotacao_dao.dart';
import '../../core/models/anotacao.dart';
import '../../core/models/user.dart';
import '../../core/models/propriedade.dart';
import '../../core/theme/app_theme.dart';
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
  List<Anotacao> _allRegistros = [];
  List<Anotacao> _filteredRegistros = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _dao.getAnotacoesByPropriedade(widget.propriedade.id!);
    setState(() {
      _allRegistros = data;
      _filteredRegistros = data;
      _isLoading = false;
    });
  }

  void _filterList(String query) {
    setState(() {
      _filteredRegistros = _allRegistros.where((r) {
        final activity = r.nomeAtividade?.toLowerCase() ?? '';
        final culture = r.nomeCultura?.toLowerCase() ?? '';
        final local = r.nomeLocal?.toLowerCase() ?? '';
        final area = r.nomeArea?.toLowerCase() ?? '';
        final search = query.toLowerCase();
        return activity.contains(search) || 
               culture.contains(search) || 
               local.contains(search) || 
               area.contains(search);
      }).toList();
    });
  }

  Color _activityColor(String? nome) {
    final n = nome?.toLowerCase() ?? '';
    if (n.contains('colheit')) return const Color(0xFFF59E0B);
    if (n.contains('plant')) return const Color(0xFF22C55E);
    if (n.contains('irrig')) return const Color(0xFF3B82F6);
    if (n.contains('adub') || n.contains('nutri')) return const Color(0xFF14B8A6);
    if (n.contains('preparo') || n.contains('solo')) return const Color(0xFF92400E);
    if (n.contains('poda')) return const Color(0xFFEC4899);
    return AppTheme.primaryGreen;
  }

  IconData _activityIcon(String? nome) {
    final n = nome?.toLowerCase() ?? '';
    if (n.contains('colheit')) return MdiIcons.barley;
    if (n.contains('plant')) return MdiIcons.sprout;
    if (n.contains('irrig')) return MdiIcons.waterPump;
    if (n.contains('adub') || n.contains('nutri')) return MdiIcons.flask;
    if (n.contains('preparo') || n.contains('solo')) return MdiIcons.shovel;
    if (n.contains('poda')) return MdiIcons.scissorsCutting;
    return MdiIcons.clipboardTextOutline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Anotações do Campo'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterList,
              decoration: InputDecoration(
                hintText: 'Buscar por atividade, cultura ou local...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _filterList('');
                      },
                    )
                  : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
                    _searchController.text.isEmpty 
                      ? 'Nenhuma anotação registrada.' 
                      : 'Nenhum resultado para a busca.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredRegistros.length,
              itemBuilder: (context, index) {
                final registro = _filteredRegistros[index];
                final color = _activityColor(registro.nomeAtividade);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnotacoesDetailScreen(registro: registro),
                        ),
                      );
                      if (result == true) _loadData();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_activityIcon(registro.nomeAtividade), color: color, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      registro.nomeAtividade ?? 'Atividade',
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                    ),
                                    Text(
                                      DateFormat('dd/MM').format(registro.dataCriacao),
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${registro.nomeLocal ?? ''} • ${registro.nomeArea ?? ''}',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                                if (registro.nomeCultura != null || registro.quantidade > 0) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      if (registro.nomeCultura != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            registro.nomeCultura!,
                                            style: TextStyle(color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (registro.quantidade > 0)
                                        Text(
                                          registro.quantidade % 1 == 0
                                              ? '${registro.quantidade.toInt()} ${registro.unidadeMedida ?? ''}'
                                              : '${registro.quantidade} ${registro.unidadeMedida ?? ''}',
                                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey.shade300),
                        ],
                      ),
                    ),
                  ),
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
          if (result == true) _loadData();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Anotação'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
}