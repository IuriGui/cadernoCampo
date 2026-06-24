import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../data/models/local.dart';
import '../../data/models/plantio_ativo.dart';
import '../../logic/provider/auth_provider.dart';
import '../../logic/provider/clima_provider.dart';
import '../../logic/provider/home_provider.dart';
import '../widgets/anotacao_card.dart';
import '../widgets/home/weather_card.dart';
import 'activity/anotacoes_detail_screen.dart';
import 'canaisEscoamento/canal_escoamento_screen.dart';
import 'localAndAreaCultivo/register_local_screen.dart';
import 'supply/insumo_screen.dart';
import 'supply/register_insumo_screen.dart';
import 'localAndAreaCultivo/local_screen.dart';
import 'activity/anotacoes_list_screen.dart';
import 'property/propriedade_screen.dart';
import 'localAndAreaCultivo/local_detail_screen.dart';
import 'property/register_property_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider(authProvider)..carregar()),
        ChangeNotifierProvider(create: (_) => ClimaProvider()..carregarClima()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final auth = context.read<AuthProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      drawer: const _HomeDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: auth.propriedade == null
              ? const _NoPropertyView()
              : const _MainContent(),
        ),
      ),
      floatingActionButton: auth.propriedade == null
          ? null
          : const _HomeFAB(),
    );
  }
}

class _HomeFAB extends StatefulWidget {
  const _HomeFAB();

  @override
  State<_HomeFAB> createState() => _HomeFABState();
}

class _HomeFABState extends State<_HomeFAB> with SingleTickerProviderStateMixin {
  bool _aberto = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _aberto = !_aberto);
    _aberto ? _controller.forward() : _controller.reverse();
  }

  void _fechar() {
    setState(() => _aberto = false);
    _controller.reverse();
  }

  Future<void> _acao(Widget screen) async {
    _fechar();
    final provider = context.read<HomeProvider>();
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    provider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final propriedade = context.read<AuthProvider>().propriedade!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Opções
        FadeTransition(
          opacity: _expandAnim,
          child: ScaleTransition(
            scale: _expandAnim,
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _FABOption(
                  icon: MdiIcons.packageVariantClosed,
                  label: 'Registrar Insumo',
                  color: const Color(0xFF1976D2),
                  onPressed: () => _acao(RegisterInsumoScreen(propriedade: propriedade)),
                ),
                const SizedBox(height: 12),
                _FABOption(
                  icon: MdiIcons.tractorVariant,
                  label: 'Nova Anotação',
                  color: const Color(0xFF2E7D32),
                  onPressed: () => _acao(LocalScreen(selectionMode: true)),
                ),
                const SizedBox(height: 16),
                _FABOption(
                  icon: Icons.location_on,
                  label: 'Novo Local',
                  color: const Color(0xFF2E7D32),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterLocalScreen(propriedade: context.read<AuthProvider>().propriedade!),
                    ),
                  ),
                ),
                const SizedBox(height: 16)
              ],
            ),
          ),
        ),
        // Botão principal
        FloatingActionButton(
          heroTag: 'fab_main',
          backgroundColor: const Color(0xFF2E7D32),
          onPressed: _toggle,
          child: AnimatedRotation(
            turns: _aberto ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _FABOption extends StatelessWidget {
  const _FABOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          heroTag: label,
          backgroundColor: color,
          onPressed: onPressed,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<HomeProvider>();
    final user = auth.user!;
    final produtor = provider.produtor;
    final propriedade = auth.propriedade;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
            accountName: Text(
              produtor?.nome ?? user.email.split('@')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user.email),
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
          if (propriedade != null) ...[
            ListTile(
              leading: Icon(MdiIcons.mapMarkerRadiusOutline),
              title: const Text('Meus Locais'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LocalScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.clipboardListOutline),
              title: const Text('Anotações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnotacoesListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.store),
              title: const Text('Canais de escoamento'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CanalEscoamentoScreen( produtor: produtor!,),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.hoopHouse),
              title: const Text('Propriedade'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropriedadeScreen(user: user),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.packageVariantClosed),
              title: const Text('Insumos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InsumoScreen(propriedade: propriedade),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(MdiIcons.truckDeliveryOutline),
            //   title: const Text('Destinos'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     if (produtor != null) {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => DestinoScreen(produtor: produtor),
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funcionalidade de configuracao em breve!'),
              ),
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

// ---------------------------------------------------------------------------
// Sem propriedade
// ---------------------------------------------------------------------------

class _NoPropertyView extends StatelessWidget {
  const _NoPropertyView();

  @override
  Widget build(BuildContext context) {
    // final auth = context.read<AuthProvider>();
    final provider = context.read<HomeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Icon(MdiIcons.homeAlertOutline, size: 100, color: Colors.orange),
        const SizedBox(height: 24),
        const Text(
          'Bem-vindo!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Voce ainda nao possui uma propriedade vinculada. Para comecar a registrar suas atividades, escolha uma das opcoes abaixo:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterPropertyScreen(),
              ),
            );
            if (result == true) provider.refresh();
          },
          icon: const Icon(Icons.add_business_outlined),
          label: const Text('Cadastrar Minha Propriedade'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Funcionalidade de solicitacao de acesso em breve!',
              ),
            ),
          ),
          icon: const Icon(Icons.person_search_outlined),
          label: const Text('Pedir Acesso a um Proprietario'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF2E7D32),
            side: const BorderSide(color: Color(0xFF2E7D32)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Conteudo principal
// ---------------------------------------------------------------------------

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _CalendarStrip(
          onDaySelected: (dia) {
            context.read<ClimaProvider>().selecionarDia(dia);
          },
        ),
        const SizedBox(height: 32),
        const WeatherCard(),
        const SizedBox(height: 32),
        _CultivosSection(plantios: provider.plantiosAtivos),
        const SizedBox(height: 32),
        _LocaisSection(locais: provider.locais),
        // const SizedBox(height: 32),
        // _AcoesSection(),
        const SizedBox(height: 32),
        const _AnotacoesDoDiaSection(),
        const SizedBox(height: 32),

      ],
    );
  }
}

class _CultivosSection extends StatelessWidget {
  const _CultivosSection({
    required this.plantios,
    this.onVerTodos,
    this.onTapPlantio,
  });

  final List<PlantioAtivo> plantios;
  final VoidCallback? onVerTodos;
  final void Function(PlantioAtivo plantio)? onTapPlantio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Minhas culturas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (onVerTodos != null)
              TextButton(
                onPressed: onVerTodos,
                child: const Text(
                  'Ver todos',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (plantios.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Nenhum plantio ativo no momento.',
              style: TextStyle(color: Colors.black54),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plantios.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final plantio = plantios[index];
              return _PlantioAtivoCard(
                plantio: plantio,
                onTap: onTapPlantio == null ? null : () => onTapPlantio!(plantio),
              );
            },
          ),
      ],
    );
  }
}

class _PlantioAtivoCard extends StatelessWidget {
  const _PlantioAtivoCard({required this.plantio, this.onTap});

  final PlantioAtivo plantio;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFFFD9CF),
              child: const Icon(Icons.eco, color: Colors.deepOrange, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantio.nomeCultura ?? 'Cultura não informada',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${plantio.nomeArea} • ${plantio.nomeLocal}',
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plantio.tempoDecorrido,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right, color: Colors.black38, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}






// ---------------------------------------------------------------------------
// Ultimas anotacoes
// ---------------------------------------------------------------------------

class _AnotacoesDoDiaSection extends StatelessWidget {
  const _AnotacoesDoDiaSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final anotacoes = provider.anotacoesDoDia;
    // final auth = context.read<AuthProvider>();
    // final user = auth.user!;

    if (anotacoes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Anotações Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnotacoesListScreen(),
                  ),
                );
              },
              child: const Text(
                'Ver todas',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: anotacoes.length,
          itemBuilder: (context, index) {
            return AnotacaoCard(
              registro: anotacoes[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnotacoesDetailScreen(anotacaoId: anotacoes[index].id!),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Calendario
// ---------------------------------------------------------------------------

class _CalendarStrip extends StatefulWidget {
  const _CalendarStrip({this.onDaySelected});

  final void Function(DateTime data)? onDaySelected;

  @override
  State<_CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends State<_CalendarStrip> {
  late DateTime _selecionado;
  late List<DateTime> _dias;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    _selecionado = DateTime(hoje.year, hoje.month, hoje.day);
    // últimos 7 dias, terminando em hoje
    _dias = List.generate(7, (i) => _selecionado.subtract(Duration(days: 6 - i)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _dias.map((dia) {
        final isSelected = dia.day == _selecionado.day &&
            dia.month == _selecionado.month &&
            dia.year == _selecionado.year;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _selecionado = dia);
              widget.onDaySelected?.call(dia);
            },
            child: _CalendarDay(
              label: DateFormat('E', 'pt_BR').format(dia).replaceAll('.', ''),
              date: dia.day.toString(),
              isSelected: isSelected,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final String label;
  final String date;
  final bool isSelected;

  const _CalendarDay({
    required this.label,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.green : Colors.grey;
    final weight = isSelected ? FontWeight.bold : FontWeight.normal;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontWeight: weight),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: isSelected
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.green, width: 2),
                  ),
                )
              : null,
          child: Text(
            date,
            style: TextStyle(fontSize: 18, fontWeight: weight, color: color),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Locais
// ---------------------------------------------------------------------------

class _LocaisSection extends StatelessWidget {
  const _LocaisSection({required this.locais});

  final List<Local> locais;

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

  String _formatArea(double areaEmMetros) {
    return areaEmMetros >= 10000
        ? '${(areaEmMetros / 10000).toStringAsFixed(1)} ha'
        : '${areaEmMetros.toStringAsFixed(0)} m²';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final provider = context.read<HomeProvider>();
    final user = auth.user!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Locais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => LocalScreen()));
                provider.refresh();
              },
              child: const Text('Ver todos', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (locais.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Nenhum local cadastrado.', style: TextStyle(color: Colors.black54)),
          )
        else
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: locais.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final local = locais[index];
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LocalDetailScreen(local: local, user: user)),
                    );
                    provider.refresh();
                  },
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(_iconByTipo(local.tipo), size: 18, color: const Color(0xFF2E7D32)),
                            ),
                            const Spacer(),
                            if (local.quebraVento)
                               Icon(MdiIcons.weatherWindy, size: 16, color: Colors.blueGrey),
                            if (local.areaSensivel)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          local.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${local.tipo} • ${_formatArea(local.areaEmMetros)}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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

// ---------------------------------------------------------------------------
// Acoes
// ---------------------------------------------------------------------------

class _AcoesSection extends StatelessWidget {
  const _AcoesSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeProvider>();
    final auth = context.read<AuthProvider>();

    final propriedade = auth.propriedade!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações Rápidas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _AcaoButton(
              icon: MdiIcons.tractorVariant,
              label: 'Nova Anotação',
              color: const Color(0xFF2E7D32),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LocalScreen(
                      selectionMode: true,
                    ),
                  ),
                );
                provider.refresh();
              },
            ),
            _AcaoButton(
              icon: MdiIcons.packageVariantClosed,
              label: 'Registrar Insumo',
              color: const Color(0xFF1976D2),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RegisterInsumoScreen(propriedade: propriedade),
                  ),
                );
                provider.refresh();
              },
            ),

          ],
        ),
      ],
    );
  }
}

class _AcaoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _AcaoButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color.withDarkness(0.2),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ColorBrightness on Color {
  Color withDarkness(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
