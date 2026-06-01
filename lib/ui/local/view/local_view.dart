import 'package:caderno_de_campo/domain/models/propriedade/propriedade.dart';
import 'package:caderno_de_campo/ui/local/create/local_create_screen.dart';
import 'package:caderno_de_campo/ui/local/view/local_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../detail/local_detail_screen.dart';

class LocalView extends StatelessWidget {
  final bool selectionMode;

  const LocalView({
    super.key,
    required this.selectionMode,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocalViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? 'Selecione o Local'
              : 'Meus Locais',
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (_) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (vm.locais.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum local encontrado nesta propriedade',
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.locais.length,
              itemBuilder: (context, index) {
                final local = vm.locais[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      local.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${local.tipo} • ${local.areaEmMetros}m²',
                    ),
                    trailing:
                    const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LocalDetailScreen(
                            local: local,
                          ),
                        ),
                      );

                      if (result == true) {
                        await vm.recarregar();
                      }
                    }
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: selectionMode
          ? null
          : FloatingActionButton(
        onPressed: () async {
          final result =
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  LocalCreateScreen(
                    propriedade:
                    vm.propriedade,
                  ),
            ),
          );

          if (result == true) {
            await vm.recarregar();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
