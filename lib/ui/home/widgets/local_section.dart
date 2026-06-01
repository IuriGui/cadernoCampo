import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/models/local/local.dart';
import '../../../domain/models/propriedade/propriedade.dart';
import '../../local/view/local_screen.dart';

class LocalSection extends StatelessWidget {

  final List<Local> locais;
  Propriedade propriedade;

  LocalSection({super.key, required this.locais, required this.propriedade});

  IconData _iconByTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'estufa':
        return MdiIcons.hoopHouse;
      case 'campo aberto':
        return MdiIcons.sprout;
      case 'pomar':
        return MdiIcons.treeOutline;
      case 'hidroponia':
        return MdiIcons.water;
      default:
        return MdiIcons.mapMarker;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.redAccent.shade100,
      Colors.greenAccent.shade400,
      Colors.yellow,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Locais',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LocalScreen(propriedade: propriedade),
                  ),
                );
                // provider.refresh();
              },
              child: const Text(
                'Ver todos',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (locais.isEmpty)
          const Text('Nenhum local cadastrado.')
        else
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: locais.length,
              itemBuilder: (context, index) {
                final local = locais[index];
                final color = colors[index % colors.length];
                return GestureDetector(
                  onTap: () async {
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => LocalDetailScreen(local: local, user: user),
                    //   ),
                    // );
                    // provider.refresh();
                  },
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          child: Icon(_iconByTipo(local.tipo), color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          local.nome,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

      ],
    );
  }
}