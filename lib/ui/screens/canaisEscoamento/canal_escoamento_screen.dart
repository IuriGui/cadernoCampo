import 'package:caderno_de_campo/ui/screens/canaisEscoamento/canal_escoamento_detail_screen.dart';
import 'package:caderno_de_campo/ui/screens/canaisEscoamento/register_canal_escoamento_screen.dart';
import 'package:flutter/material.dart';

import '../../../data/dao/canal_escoamento_dao.dart';
import '../../../data/models/canal.dart';
import '../../../data/models/produtor.dart';

class CanalEscoamentoScreen extends StatefulWidget {
  final Produtor produtor;

  const CanalEscoamentoScreen({super.key, required this.produtor});

  @override
  State<CanalEscoamentoScreen> createState() => _CanalEscoamentoScreenState();
}

class _CanalEscoamentoScreenState extends State<CanalEscoamentoScreen> {
  final CanalEscoamentoDAO _canalDAO = CanalEscoamentoDAO();
  late Future<List<CanalEscoamento>> _canaisFuture;

  @override
  void initState() {
    super.initState();
    _refreshCanais();
  }

  void _refreshCanais() {
    setState(() {
      _canaisFuture = _canalDAO.getCanaisByProdutor(widget.produtor.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canais de escoamento')),
      body: SafeArea(
        child: FutureBuilder<List<CanalEscoamento>>(
          future: _canaisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            final canais = snapshot.data ?? [];

            if (canais.isEmpty) {
              return const Center(
                child: Text('Nenhum canal de escoamento cadastrado.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: canais.length,
              itemBuilder: (context, index) {
                final canal = canais[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(canal.nome),
                    subtitle: Text('Tipo: ${canal.tipo}'),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CanalEscoamentoDetailScreen(escoamento: canal)
                        ),
                      );

                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Excluir canal'),
                            content: const Text('Tem certeza que deseja excluir este canal?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _canalDAO.softDeleteCanalEscoamento(canal.id!);
                          _refreshCanais();
                        }
                      },
                    ),
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
              builder: (context) => RegisterCanalEscoamentoScreen(produtor: widget.produtor),
            ),
          );
          if (result == true) {
            _refreshCanais();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
