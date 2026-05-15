import 'package:flutter/material.dart';

class AsyncListView<T> extends StatelessWidget {
  final Future<List<T>> future;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final IconData emptyIcon;
  final EdgeInsets padding;

  const AsyncListView({
    super.key,
    required this.future,
    required this.itemBuilder,
    this.emptyMessage = 'Nenhum item encontrado.',
    this.emptyIcon = Icons.inbox_outlined,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(emptyIcon, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(emptyMessage, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: padding,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) =>
              itemBuilder(context, snapshot.data![index]),
        );
      },
    );
  }
}