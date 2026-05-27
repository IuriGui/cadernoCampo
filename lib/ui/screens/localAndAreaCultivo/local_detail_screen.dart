import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../data/models/area_cultivo.dart';
import '../../../data/models/local.dart';
import '../../../data/models/user.dart';
import '../../../logic/provider/local_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentLocal.nome),
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
                setState(() {
                  _currentLocal = updated;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir Local',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocalInfoCard(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Áreas de Cultivo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildAreasList(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAreaDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAreasList(BuildContext context) {
    final provider = context.watch<LocalProvider>();

    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.areas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('Nenhuma área de cultivo registrada.')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.areas.length,
      itemBuilder: (context, index) {
        final area = provider.areas[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.lightGreen,
            child: Icon(MdiIcons.sprout, color: Colors.white, size: 20),
          ),
          title: Text(area.nome),
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
        );
      },
    );
  }

  Widget _buildLocalInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(MdiIcons.tagOutline, 'Tipo', _currentLocal.tipo),
            const Divider(),
            _buildInfoRow(MdiIcons.rulerSquare, 'Área', '${_currentLocal.areaEmMetros} m²'),
            const Divider(),
            _buildInfoRow(
              MdiIcons.windPowerOutline,
              'Quebra-vento',
              _currentLocal.quebraVento ? 'Presente' : 'Ausente',
            ),
            const Divider(),
            _buildInfoRow(
              MdiIcons.alertOutline,
              'Área Sensível',
              _currentLocal.areaSensivel ? 'Sim' : 'Não',
            ),
            if (_currentLocal.observacoes != null && _currentLocal.observacoes!.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Observações:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(_currentLocal.observacoes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
