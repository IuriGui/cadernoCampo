import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../data/models/area_cultivo.dart';
import '../../../data/models/local.dart';
import '../../../data/models/user.dart';
import '../../../logic/provider/local_provider.dart';
import '../../theme/app_theme.dart';
import 'area_detail_screen.dart';
import 'edit_local_screen.dart';

class LocalDetailScreen extends StatelessWidget {
  final Local local;
  final User user;

  const LocalDetailScreen({super.key, required this.local, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocalProvider()..loadAreas(local.id!),
      child: _LocalDetailView(local: local, user: user),
    );
  }
}

class _LocalDetailView extends StatefulWidget {
  final Local local;
  final User user;

  const _LocalDetailView({required this.local, required this.user});

  @override
  State<_LocalDetailView> createState() => _LocalDetailViewState();
}

class _LocalDetailViewState extends State<_LocalDetailView> {
  late Local _currentLocal;

  @override
  void initState() {
    super.initState();
    _currentLocal = widget.local;
  }

  IconData _iconByTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'estufa':
        return MdiIcons.hoopHouse;
      case 'campo aberto':
        return MdiIcons.sprout;
      case 'pomar':
        return MdiIcons.treeOutline;
      case 'hidroponia':
        return MdiIcons.water;
      default:
        return MdiIcons.mapMarker;
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Local'),
        content: const Text(
            'Tem certeza que deseja excluir este local? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<LocalProvider>().deleteLocal(_currentLocal.id!);
      Navigator.pop(context, true);
    }
  }

  void _showAddAreaDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova Área de Cultivo'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Nome da Área'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await context.read<LocalProvider>().addArea(
                  AreaCultivo(
                    localId: _currentLocal.id!,
                    nome: titleController.text,
                  ),
                  _currentLocal.id!,
                );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalProvider>();

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
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Editar Local',
                onPressed: () async {
                  final updated = await Navigator.push<Local>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditLocalScreen(local: _currentLocal),
                    ),
                  );
                  if (updated != null) {
                    setState(() => _currentLocal = updated);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Excluir Local',
                onPressed: () => _confirmDelete(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _currentLocal.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: Container(
                color: AppTheme.primaryGreen,
                child: Center(
                  child: Icon(
                    _iconByTipo(_currentLocal.tipo),
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),

          // ── Info Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow(MdiIcons.tagOutline, 'Tipo', _currentLocal.tipo),
                      const Divider(height: 24),
                      _buildInfoRow(
                        MdiIcons.rulerSquare,
                        'Área',
                        '${_currentLocal.areaEmMetros.toStringAsFixed(0)} m²',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        MdiIcons.windPowerOutline,
                        'Quebra-vento',
                        _currentLocal.quebraVento ? 'Presente' : 'Ausente',
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        MdiIcons.alertOutline,
                        'Área Sensível',
                        _currentLocal.areaSensivel ? 'Sim' : 'Não',
                      ),
                      if (_currentLocal.observacoes != null &&
                          _currentLocal.observacoes!.isNotEmpty) ...[
                        const Divider(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Observações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _currentLocal.observacoes!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Section title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'ÁREAS DE CULTIVO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // ── Areas list ──
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (provider.areas.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(MdiIcons.sproutOutline, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhuma área de cultivo registrada.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final area = provider.areas[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.12),
                          child: Icon(MdiIcons.sprout, color: AppTheme.primaryGreen, size: 20),
                        ),
                        title: Text(
                          area.nome,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AreaDetailScreen(
                                area: area,
                                local: _currentLocal,
                                user: widget.user,
                              ),
                            ),
                          );
                          if (result == true && context.mounted) {
                            context.read<LocalProvider>().loadAreas(_currentLocal.id!);
                          }
                        },
                      ),
                    );
                  },
                  childCount: provider.areas.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAreaDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Área'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}