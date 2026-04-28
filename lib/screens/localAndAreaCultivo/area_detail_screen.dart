import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/registro_atividade_dao.dart';
import '../../core/models/area_cultivo.dart';
import '../../core/models/registro_atividade.dart';
import '../../core/models/user.dart';
import '../../core/models/local.dart';
import '../activity/register_activity_screen.dart';
import '../activity/atividades_detail_screen.dart';

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
  final RegistroAtividadeDAO _registroDAO = RegistroAtividadeDAO();
  late Future<List<RegistroAtividade>> _registrosFuture;

  @override
  void initState() {
    super.initState();
    _refreshRegistros();
  }

  void _refreshRegistros() {
    setState(() {
      _registrosFuture = _registroDAO.getRegistrosByArea(widget.area.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area.titulo),
      ),
      body: SafeArea(
        child: FutureBuilder<List<RegistroAtividade>>(
          future: _registrosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Nenhum registro nesta área.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            final registros = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(MdiIcons.clipboardTextClockOutline, color: Theme.of(context).primaryColor),
                    ),
                    title: Text(
                      registro.nomeAtividade ?? 'Atividade',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(MdiIcons.calendarCheck, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(DateFormat('dd/MM/yyyy').format(registro.dataOcorrencia)),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(MdiIcons.account, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    registro.nomeResponsavel ?? 'N/A',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (registro.tempoEstimadoMin != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(MdiIcons.clockOutline, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('${registro.tempoEstimadoMin} min'),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AtividadesDetailScreen(registro: registro),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterActivityScreen(
                local: widget.local,
                user: widget.user,
                preSelectedArea: widget.area,
              ),
            ),
          );
          if (result == true) {
            _refreshRegistros();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
