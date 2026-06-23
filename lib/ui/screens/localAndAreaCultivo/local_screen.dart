import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/dao/local_dao.dart';
import '../../../data/models/local.dart';
import '../../../data/models/user.dart';
import '../../../data/models/propriedade.dart';
import '../../../logic/provider/auth_provider.dart';
import '../../../logic/provider/home_provider.dart';
import '../../widgets/async_list_view.dart';
import 'local_detail_screen.dart';
import '../activity/register_anotacao_screen.dart';
import 'register_local_screen.dart';

class LocalScreen extends StatefulWidget {
  final bool selectionMode;
  
  const LocalScreen({
    super.key,
    this.selectionMode = false
  });

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


  @override
  Widget build(BuildContext context) {

    final propriedade = context.read<AuthProvider>().propriedade!;
    final user = context.read<AuthProvider>().user!;


    return Scaffold(
      appBar: AppBar( title: Text (widget.selectionMode ? 'Selecione o Local' : 'Meus Locais')),
      body: SafeArea(
          child: AsyncListView<Local>(
            future: _locaisFuture,
            emptyMessage: "Nenhum local encontrado nesta propriedade",
            emptyIcon: Icons.location_on_outlined,
            itemBuilder: (context, local) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.location_on, color: Colors.white),
                ),
                title: Text(
                  local.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${local.tipo} • ${local.areaEmMetros}m²'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  if (widget.selectionMode) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterAnotacaoScreen(
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
                        builder: (context) => LocalDetailScreen(local: local, user: user),
                      ),
                    );
                    if (result == true) {
                      _refreshLocais();
                    }
                  }
                },
              ),
            ),

          ),

      ),
      floatingActionButton: widget.selectionMode
          ? null
          : FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterLocalScreen(propriedade: propriedade),
            ),
          );
          if (result == true) _refreshLocais();
        },
        child: const Icon(Icons.add),
      ),
    );

  }
}
