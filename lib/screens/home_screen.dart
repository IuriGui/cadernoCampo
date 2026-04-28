import 'package:flutter/material.dart';
import '../core/models/user.dart';
import '../core/models/local.dart';
import '../core/models/propriedade.dart';
import '../core/dao/local_dao.dart';
import '../core/dao/propriedade_dao.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'supply/insumo_screen.dart';
import 'localAndAreaCultivo/local_screen.dart';
import 'activity/atividades_list_screen.dart';
import 'property/propriedade_screen.dart';
import 'localAndAreaCultivo/local_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalDAO _localDAO = LocalDAO();
  final PropriedadeDAO _propriedadeDAO = PropriedadeDAO();
  
  late Future<List<Local>> _locaisFuture;
  Propriedade? _propriedade;
  bool _isLoadingProp = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final prop = await _propriedadeDAO.getPropriedadeByUsuario(widget.user.id!);
      if (mounted) {
        setState(() {
          _propriedade = prop;
          _isLoadingProp = false;
          if (_propriedade != null) {
            _locaisFuture = _localDAO.getTopThreeLocais(_propriedade!.id!);
          } else {
            _locaisFuture = Future.value([]);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProp = false;
          _locaisFuture = Future.error(e);
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProp) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Tela - Home",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildCalendar(),
            const SizedBox(height: 32),
            _buildWeatherHeader(context),
            const SizedBox(height: 24),
            _buildWeatherMainInfo(),
            const SizedBox(height: 32),
            _buildWeatherDetails(),
            const SizedBox(height: 32),
            _buildLocaisSection(context),
            const SizedBox(height: 32),
            _buildAcoesSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
            accountName: Text(
              widget.user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF2E7D32)),
            ),
          ),
          ListTile(
            leading: Icon(MdiIcons.homeOutline),
            title: const Text('Início'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(MdiIcons.mapMarkerRadiusOutline),
            title: const Text('Meus Locais'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LocalScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.clipboardListOutline),
            title: const Text('Registros de Atividades'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AtividadesListScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.sproutOutline),
            title: const Text('Áreas de Cultivo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => LocalScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.hoopHouse),
            title: const Text ('Propriedade'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PropriedadeScreen(user: widget.user)));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.packageVariantClosed),
            title: const Text ('Insumos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => InsumoScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configurações'),
            onTap: () => Navigator.pop(context),
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

  Widget _buildCalendar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCalendarDay("Seg", "12"),
        _buildCalendarDay("Ter", "13"),
        _buildCalendarDay("Qua", "14", isSelected: true),
        _buildCalendarDay("Qui", "15"),
        _buildCalendarDay("Sex", "16"),
      ],
    );
  }

  Widget _buildCalendarDay(String day, String date, {bool isSelected = false}) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Previsão do tempo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: const [
            Icon(Icons.location_on_outlined, color: Colors.green, size: 18),
            SizedBox(width: 4),
            Text(
              "Santa maria, RS",
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherMainInfo() {
    return Row(
      children: [
        Image.asset(
          'lib/assets/imgs/nubladoChanceChuva.png',
          width: 152,
          height: 152,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "19°",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("/", style: TextStyle(fontSize: 32, color: Colors.grey)),
                  ),
                  const Text(
                    "29°",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text("mín.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 40),
                  Text("máx.", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Parcialmente nublado\ncom chance de chuva",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.cloud_queue, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Chuva", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("30%", style: TextStyle(fontSize: 16)),
                Text("(5 mm)", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.water_drop_outlined, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Umidade", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("30%", style: TextStyle(fontSize: 16)),
                Text("do ar", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.air, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Vento", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("12 km/h", style: TextStyle(fontSize: 16, color: Colors.green)),
                Text("NE", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocaisSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Locais",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalScreen(user: widget.user)),
                );
                _refreshData();
              },
              child: const Text("Ver todos", style: TextStyle(color: Colors.green))
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Local>>(
          future: _locaisFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Erro ao carregar locais: ${snapshot.error}');
            }
            final locais = snapshot.data ?? [];
            if (locais.isEmpty) {
              return const Text('Nenhum local cadastrado.');
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: locais.asMap().entries.map((entry) {
                int idx = entry.key;
                Local local = entry.value;
                Color color;
                switch (idx) {
                  case 0:
                    color = Colors.redAccent.shade100;
                    break;
                  case 1:
                    color = Colors.greenAccent.shade400;
                    break;
                  case 2:
                    color = Colors.yellow;
                    break;
                  default:
                    color = Colors.grey;
                }
                return _buildLocalItem(local, color);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconByTipo(String tipo) {
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

  Widget _buildLocalItem(Local local, Color color) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocalDetailScreen(local: local, user: widget.user)),
        );
        _refreshData();
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(_getIconByTipo(local.tipo), color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            local.nome, 
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAcoesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ações",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildAcaoButton(
              MdiIcons.tractorVariant, 
              "Nova Atividade", 
              const Color(0xFF5C6BC0),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalScreen(user: widget.user, selectionMode: true),
                  ),
                );
                _refreshData();
              },
            ),
            _buildAcaoButton(MdiIcons.shovel, "Novo Canteiro", const Color(0xFF8D6E63)),
            _buildAcaoButton(MdiIcons.sprout, "Novo Plantio", const Color(0xFF43A047)),
            _buildAcaoButton(MdiIcons.packageVariantClosed, "Registrar Insumo", const Color(0xFF26A69A)),
          ],
        )
      ],
    );
  }

  Widget _buildAcaoButton(IconData icon, String label, Color color, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
