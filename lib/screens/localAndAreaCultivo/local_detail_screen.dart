import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/area_cultivo_dao.dart';
import '../../core/models/local.dart';
import '../../core/models/area_cultivo.dart';
import '../../core/models/user.dart';
import 'area_detail_screen.dart';
import '../activity/register_activity_screen.dart';

class LocalDetailScreen extends StatefulWidget {
  final Local local;
  final User user;

  const LocalDetailScreen({super.key, required this.local, required this.user});

  @override
  State<LocalDetailScreen> createState() => _LocalDetailScreenState();
}

class _LocalDetailScreenState extends State<LocalDetailScreen> {
  final AreaCultivoDAO _areaDAO = AreaCultivoDAO();
  late Future<List<AreaCultivo>> _areasFuture;

  @override
  void initState() {
    super.initState();
    _refreshAreas();
  }

  void _refreshAreas() {
    setState(() {
      _areasFuture = _areaDAO.getAreasByLocal(widget.local.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.local.nome),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.clipboardEditOutline),
            tooltip: 'Registrar Atividade',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterActivityScreen(
                    local: widget.local,
                    user: widget.user,
                  ),
                ),
              );
            },
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
            _buildAreasList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAreaDialog,
        child: const Icon(Icons.add),
      ),
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
            _buildInfoRow(MdiIcons.tagOutline, 'Tipo', widget.local.tipo),
            const Divider(),
            _buildInfoRow(MdiIcons.rulerSquare, 'Área', '${widget.local.areaEmMetros} m²'),
            const Divider(),
            _buildInfoRow(
              MdiIcons.windPowerOutline, 
              'Quebra-vento', 
              widget.local.quebraVento ? 'Presente' : 'Ausente'
            ),
            const Divider(),
            _buildInfoRow(
              MdiIcons.alertOutline, 
              'Área Sensível', 
              widget.local.areaSensivel ? 'Sim' : 'Não'
            ),
            if (widget.local.observacoes != null && widget.local.observacoes!.isNotEmpty) ...[
              const Divider(),
              const Text(
                'Observações:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(widget.local.observacoes!),
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
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAreasList() {
    return FutureBuilder<List<AreaCultivo>>(
      future: _areasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ));
        }
        
        final areas = snapshot.data ?? [];
        if (areas.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text('Nenhuma área de cultivo registrada.')),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: areas.length,
          itemBuilder: (context, index) {
            final area = areas[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightGreen,
                child: Icon(MdiIcons.sprout, color: Colors.white, size: 20),
              ),
              title: Text(area.nome),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AreaDetailScreen(
                      area: area,
                      local: widget.local,
                      user: widget.user,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showAddAreaDialog() {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Área de Cultivo'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Nome da Área'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final scaffoldContext = Navigator.of(context);
                final novaArea = AreaCultivo(
                  localId: widget.local.id!,
                  nome: titleController.text,
                );
                await _areaDAO.insertAreaCultivo(novaArea);
                scaffoldContext.pop();
                _refreshAreas();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
