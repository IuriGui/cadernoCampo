import 'package:flutter/material.dart';
import '../../core/dao/local_dao.dart';
import '../../core/dao/propriedade_dao.dart';
import '../../core/models/local.dart';
import '../../core/models/user.dart';
import '../../core/models/propriedade.dart';
import 'local_detail_screen.dart';
import '../activity/register_activity_screen.dart';
import 'register_local_screen.dart';

class LocalScreen extends StatefulWidget {
  final User user;
  final bool selectionMode;
  const LocalScreen({super.key, required this.user, this.selectionMode = false});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  final LocalDAO _localDAO = LocalDAO();
  final PropriedadeDAO _propriedadeDAO = PropriedadeDAO();
  
  late Future<List<Local>> _locaisFuture;
  Propriedade? _propriedade;
  bool _isLoadingProp = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prop = await _propriedadeDAO.getPropriedadeByUsuario(widget.user.id!);
      if (mounted) {
        setState(() {
          _propriedade = prop;
          _isLoadingProp = false;
          _refreshLocais();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProp = false;
          _locaisFuture = Future.error(e);
        });
      }
    }
  }

  void _refreshLocais() {
    if (_propriedade != null) {
      setState(() {
        _locaisFuture = _localDAO.getLocaisByPropriedade(_propriedade!.id!);
      });
    } else {
      _locaisFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProp) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.selectionMode ? 'Selecione o Local' : 'Meus Locais')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectionMode ? 'Selecione o Local' : 'Meus Locais'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Local>>(
          future: _locaisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhum local cadastrado.'));
            }

            final locais = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: locais.length,
              itemBuilder: (context, index) {
                final local = locais[index];
                return Card(
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
                    subtitle: Text('${local.tipo} • ${local.areaM2}m²'),
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
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: (widget.selectionMode || _propriedade == null)
          ? null 
          : FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterLocalScreen(propriedade: _propriedade!)),
                );
                if (result == true) {
                  _refreshLocais();
                }
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
