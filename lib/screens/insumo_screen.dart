import 'package:caderno_de_campo/core/dao/insumo_dao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/models/insumo.dart';
import 'registersScreens/register_insumo_screen.dart';

class InsumoScreen extends StatefulWidget {
  const InsumoScreen({super.key});

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
      _insumosFuture = _dao.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insumos'),
      ),
      body: FutureBuilder<List<Insumo>>(
        future: _insumosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar insumos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum insumo encontrado.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final insumos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: insumos.length,
            itemBuilder: (context, index) {
              final insumo = insumos[index];
              return Card(
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
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterInsumoScreen()),
          );
          if (result == true) {
            _refreshList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
