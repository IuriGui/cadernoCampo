import 'package:flutter/material.dart';

class InsumoScreen extends StatefulWidget {
  const InsumoScreen({super.key});

  @override
  State<InsumoScreen> createState() => _InsumoScreenState();
}
class _InsumoScreenState extends State<InsumoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insumos'),
      ),
      body: const Center(
        child: Text('Insumo Screen'),
      ),
    );
  }
}
