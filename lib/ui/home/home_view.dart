
import 'package:caderno_de_campo/ui/home/widgets/home_drawer.dart';
import 'package:caderno_de_campo/ui/home/widgets/main_content.dart';
import 'package:caderno_de_campo/ui/home/widgets/no_property.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: HomeDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: vm.propriedade == null
              ? NoPropertyView()
              : MainContent(locais: vm.locais, propriedade: vm.propriedade!),
        ),
      ),
    );
  }
}