import 'package:caderno_de_campo/ui/propriedade/propriedade_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../home_viewmodel.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
            accountName: Text(
              vm.produtor?.nome ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(vm.produtor.usuario.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF2E7D32)),
            ),
          ),
          ListTile(
            leading: Icon(MdiIcons.homeOutline),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
          if (vm.propriedade != null) ...[
            ListTile(
              leading: Icon(MdiIcons.mapMarkerRadiusOutline),
              title: const Text('Meus Locais'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => LocalScreen()));
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.clipboardListOutline),
              title: const Text('Anotações'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => AnotacoesListScreen()));
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.hoopHouse),
              title: const Text('Propriedade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => PropriedadeScreen(user: vm.produtor.usuario)));
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.packageVariantClosed),
              title: const Text('Insumos'),
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (_) => InsumoScreen()));
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Funcionalidade em breve!')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}