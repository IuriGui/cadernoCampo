import 'package:flutter/material.dart';
import '../../core/dao/local_dao.dart';
import '../../core/models/local.dart';
import '../../core/models/user.dart';
import '../../core/models/propriedade.dart';
import '../../core/widgets/async_list_view.dart';
import 'local_detail_screen.dart';
import '../activity/register_activity_screen.dart';
import 'register_local_screen.dart';

class LocalScreen extends StatefulWidget {
  final User user;
  final Propriedade propriedade;
  final bool selectionMode;
  
  const LocalScreen({
    super.key, 
    required this.user, 
    required this.propriedade,
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
    setState(() {
      _locaisFuture = _localDAO.getLocaisByPropriedade(widget.propriedade.id!);
    });
  }


  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  if (widget.selectionMode) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterActivityScreen(
                          local: local,
                          user: widget.user,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocalDetailScreen(local: local, user: widget.user),
                      ),
                    );
                  }
                },
              ),
            ),
          ),

      ),

    );

  }
}
