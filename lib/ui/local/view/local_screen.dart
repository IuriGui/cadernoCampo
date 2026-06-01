import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/propriedade/propriedade.dart';
import 'local_view.dart';
import 'local_viewmodel.dart';

class LocalScreen extends StatelessWidget {
  final Propriedade propriedade;

  const LocalScreen({
    super.key,
    required this.propriedade,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      LocalViewmodel(propriedade)
        ..carregarLocais(),
      child: const LocalView(
        selectionMode: false,
      ),
    );
  }
}