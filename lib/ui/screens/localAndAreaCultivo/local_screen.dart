import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../data/dao/local_dao.dart';
import '../../../data/models/local.dart';
import '../../../data/models/user.dart';
import '../../../logic/provider/auth_provider.dart';
import '../../../logic/provider/home_provider.dart';
import '../../theme/app_theme.dart';
import 'local_detail_screen.dart';
import '../activity/register_anotacao_screen.dart';
import 'register_local_screen.dart';

class LocalScreen extends StatefulWidget {
  final bool selectionMode;

  const LocalScreen({super.key, this.selectionMode = false});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final LocalDAO _localDAO = LocalDAO();
  late Future<List<Local>> _locaisFuture;

  @override
  void initState() {
    super.initState();
    _refreshLocais();
  }

  void _refreshLocais() {
    final propriedade = context.read<AuthProvider>().propriedade!;
    setState(() {
      _locaisFuture = _localDAO.getLocaisByPropriedade(propriedade.id!);
    });
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

  String _formatArea(double area) {
    return area >= 10000
        ? '${(area / 10000).toStringAsFixed(1)} ha'
        : '${area.toStringAsFixed(0)} m²';
  }

  @override
  Widget build(BuildContext context) {
    final propriedade = context.read<AuthProvider>().propriedade!;
    final user = context.read<AuthProvider>().user!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.selectionMode ? 'Selecione o Local' : 'Meus Locais',
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
                    MdiIcons.mapMarkerMultipleOutline,
                    size: 52,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'LOCAIS CADASTRADOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          FutureBuilder<List<Local>>(
            future: _locaisFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Erro ao carregar locais.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                );
              }

              final locais = snapshot.data ?? [];

              if (locais.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.mapMarkerOffOutline,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Nenhum local encontrado.',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final local = locais[index];
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
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                            AppTheme.primaryGreen.withValues(alpha: 0.12),
                            child: Icon(
                              _iconByTipo(local.tipo),
                              color: AppTheme.primaryGreen,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            local.nome,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${local.tipo} • ${_formatArea(local.areaEmMetros)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (local.quebraVento)
                                Icon(MdiIcons.weatherWindy,
                                    size: 16, color: Colors.blueGrey.shade300),
                              if (local.areaSensivel)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(Icons.warning_amber_rounded,
                                      size: 16, color: Colors.orange.shade300),
                                ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                          onTap: () async {
                            if (widget.selectionMode) {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegisterAnotacaoScreen(
                                    local: local,
                                    user: user,
                                  ),
                                ),
                              );
                              if (!context.mounted) return;
                              if (result == true) {
                                context.read<HomeProvider>().refresh();
                                Navigator.pop(context, true);
                              }
                            } else {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LocalDetailScreen(local: local, user: user),
                                ),
                              );
                              if (result == true) _refreshLocais();
                            }
                          },
                        ),
                      );
                    },
                    childCount: locais.length,
                  ),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: widget.selectionMode
          ? null
          : FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterLocalScreen(propriedade: propriedade),
            ),
          );
          if (result == true) _refreshLocais();
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Local'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
}