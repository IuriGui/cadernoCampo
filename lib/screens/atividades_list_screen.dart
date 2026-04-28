import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../core/dao/registro_atividade_dao.dart';
import '../core/models/registro_atividade.dart';
import '../core/models/user.dart';

class AtividadesListScreen extends StatefulWidget {
  final User user;
  const AtividadesListScreen({super.key, required this.user});

  @override
  State<AtividadesListScreen> createState() => _AtividadesListScreenState();
}

class _AtividadesListScreenState extends State<AtividadesListScreen> {
  final RegistroAtividadeDAO _dao = RegistroAtividadeDAO();
  late Future<List<RegistroAtividade>> _registrosFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _registrosFuture = _dao.getAllRegistros();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de Atividades'),
      ),
      body: FutureBuilder<List<RegistroAtividade>>(
        future: _registrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar atividades: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum registro encontrado.', style: TextStyle(color: Colors.grey)),
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
                    child: Icon(MdiIcons.clipboardCheckOutline, color: Theme.of(context).primaryColor),
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
                              Icon(MdiIcons.calendarRange, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(DateFormat('dd/MM/yyyy').format(registro.dataOcorrencia)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(MdiIcons.accountOutline, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  registro.nomeResponsavel ?? 'N/A',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(MdiIcons.mapMarkerRadiusOutline, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${registro.nomeLocal} - ${registro.nomeArea}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navegar para detalhes futuramente
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar adição de novo registro futuramente
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
