import 'package:flutter/material.dart';
import '../../core/dao/destino_dao.dart';
import '../../core/dao/produtor_dao.dart';
import '../../core/models/destino.dart';
import '../../core/models/produtor.dart';
import '../../core/widgets/async_list_view.dart';
import 'register_destino_screen.dart';
import 'register_programa_screen.dart';

class DestinoScreen extends StatefulWidget {
  final Produtor produtor;
  const DestinoScreen({super.key, required this.produtor});

  @override
  State<DestinoScreen> createState() => _DestinoScreenState();
}

class _DestinoScreenState extends State<DestinoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Destino>> _destinosFuture;
  late Future<List<Map<String, dynamic>>> _programasFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshDestinos();
    _refreshProgramas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshDestinos() {
    setState(() {
      _destinosFuture = DestinoDAO().getAllDestinos();
    });
  }

  void _refreshProgramas() {
    setState(() {
      _programasFuture = ProdutorDAO().getProgramasComercializacao(widget.produtor.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comercialização'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Destinos', icon: Icon(Icons.local_shipping_outlined)),
            Tab(text: 'Programas', icon: Icon(Icons.assignment_outlined),),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AsyncListView<Destino>(
            future: _destinosFuture,
            emptyMessage: 'Nenhum destino cadastrado.',
            itemBuilder: (context, destino) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.location_on)),
              title: Text(destino.nome),
            ),
          ),
          // Aba de Programas
          AsyncListView<Map<String, dynamic>>(
            future: _programasFuture,
            emptyMessage: 'Nenhum programa cadastrado.',
            itemBuilder: (context, programa) => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.assignment), backgroundColor: Colors.green),
              title: Text(programa['tipo'] ?? ''),
              subtitle: Text(programa['valor'] ?? ''),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _tabController.index == 0
                  ? const RegisterDestinoScreen()
                  : RegisterProgramaScreen(produtorId: widget.produtor.id!),
            ),
          );
          if (result == true) {
            _tabController.index == 0 ? _refreshDestinos() : _refreshProgramas();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
