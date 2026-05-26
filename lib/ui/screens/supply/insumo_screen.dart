import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/dao/insumo_dao.dart';
import '../../../data/models/insumo.dart';
import '../../../data/models/propriedade.dart';
import '../../widgets/async_list_view.dart';
import 'register_insumo_screen.dart';

class InsumoScreen extends StatefulWidget {
  final Propriedade propriedade;
  const InsumoScreen({super.key, required this.propriedade});

  @override
  State<InsumoScreen> createState() => _InsumoScreenState();
}

class _InsumoScreenState extends State<InsumoScreen> {
  final InsumoDAO _dao = InsumoDAO();
  late Future<List<Insumo>> _insumosFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _insumosFuture = _dao.getInsumosByPropriedade(widget.propriedade.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insumos')),
      body: SafeArea(
        child: AsyncListView<Insumo>(
          future: _insumosFuture,
          emptyMessage: 'Nenhum insumo nesta propriedade.',
          emptyIcon: Icons.inventory_2_outlined,
          itemBuilder: (context, insumo) => Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.inventory_2, color: Colors.white),
              ),
              title: Text(
                insumo.produto,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Fornecedor: ${insumo.fornecedor}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Aquisição',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(insumo.dataAquisicao),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
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
              builder: (context) => RegisterInsumoScreen(propriedade: widget.propriedade),
            ),
          );
          if (result != null) _refreshList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}