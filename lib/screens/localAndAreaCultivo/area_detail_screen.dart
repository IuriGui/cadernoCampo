import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/anotacao_dao.dart';
import '../../core/models/area_cultivo.dart';
import '../../core/models/anotacao.dart';
import '../../core/models/user.dart';
import '../../core/models/local.dart';
import '../../core/widgets/async_list_view.dart';
import '../activity/register_anotacao_screen.dart';
import '../activity/anotacoes_detail_screen.dart';

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
  final AnotacaoDAO _anotacaoDAO = AnotacaoDAO();
  late Future<List<Anotacao>> _registrosFuture;

  @override
  void initState() {
    super.initState();
    _refreshRegistros();
  }

  void _refreshRegistros() {
    setState(() {
      _registrosFuture = _anotacaoDAO.getAnotacoesByArea(widget.area.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.area.nome)),
      body: SafeArea(
        child: AsyncListView<Anotacao>(
          future: _registrosFuture,
          emptyMessage: 'Nenhum registro nesta área.',
          emptyIcon: Icons.history,
          itemBuilder: (context, registro) => Card(
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
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(MdiIcons.calendarCheck, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(DateFormat('dd/MM/yyyy').format(registro.dataCriacao)),
                  ],
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnotacoesDetailScreen(registro: registro),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterAnotacaoScreen(
                local: widget.local,
                user: widget.user,
                preSelectedArea: widget.area,
              ),
            ),
          );
          if (result == true) _refreshRegistros();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}