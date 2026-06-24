import 'package:caderno_de_campo/data/dao/anotacao_dao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../theme/app_theme.dart';
import '../relatorio/relatorio_rastreabilidade_screen.dart';

// ─── helpers de cor e ícone ───────────────────────────────────────────────────

Color _activityColor(String? nome) {
  final n = nome?.toLowerCase() ?? '';
  if (n.contains('colheit'))              return const Color(0xFFF59E0B);
  if (n.contains('destinar'))             return const Color(0xFFEF4444);
  if (n.contains('plant'))               return const Color(0xFF22C55E);
  if (n.contains('irrig'))               return const Color(0xFF3B82F6);
  if (n.contains('adub') || n.contains('nutri')) return const Color(0xFF14B8A6);
  if (n.contains('preparo') || n.contains('solo')) return const Color(0xFF92400E);
  if (n.contains('poda'))                return const Color(0xFFEC4899);
  if (n.contains('capina'))              return const Color(0xFF84CC16);
  if (n.contains('cobertura'))           return const Color(0xFF78716C);
  if (n.contains('bioinsumo'))           return const Color(0xFF8B5CF6);
  return AppTheme.primaryGreen;
}

IconData _activityIcon(String? nome) {
  final n = nome?.toLowerCase() ?? '';
  if (n.contains('colheit'))             return MdiIcons.barley;
  if (n.contains('destinar'))            return MdiIcons.truckDelivery;
  if (n.contains('plant'))              return MdiIcons.sprout;
  if (n.contains('irrig'))              return MdiIcons.waterPump;
  if (n.contains('adub') || n.contains('nutri')) return MdiIcons.flask;
  if (n.contains('preparo') || n.contains('solo')) return MdiIcons.shovel;
  if (n.contains('poda'))               return MdiIcons.scissorsCutting;
  if (n.contains('capina'))             return MdiIcons.horseshoe;
  if (n.contains('cobertura'))          return MdiIcons.layers;
  if (n.contains('bioinsumo'))          return MdiIcons.leaf;
  return MdiIcons.clipboardTextOutline;
}

// ─── tela ────────────────────────────────────────────────────────────────────

class AnotacoesDetailScreen extends StatefulWidget {
  final int anotacaoId;

  const AnotacoesDetailScreen({super.key, required this.anotacaoId});

  @override
  State<AnotacoesDetailScreen> createState() => _AnotacoesDetailScreenState();
}

class _AnotacoesDetailScreenState extends State<AnotacoesDetailScreen> {
  Map<String, dynamic>? _registro;
  bool _loading = true;
  String? _erro;

  final _dao = AnotacaoDAO();

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<void> _load() async {
    try {
      final result = await _dao.getAnotacaoDetalhadaById(widget.anotacaoId);
      print(result);
      setState(() {
        _registro = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loading = false;
      });
    }
  }

  // ── getters de conveniência ────────────────────────────────────────────────

  String? _str(String key) {
    final v = _registro?[key];
    return (v == null || v.toString().isEmpty) ? null : v.toString();
  }

  double? _dbl(String key) {
    final v = _registro?[key];
    if (v == null) return null;
    return double.tryParse(v.toString());
  }

  String _fmtQtd(double? qtd, String? unidade) {
    if (qtd == null) return '—';
    final n = qtd % 1 == 0 ? qtd.toInt().toString() : qtd.toString();
    return unidade != null ? '$n $unidade' : n;
  }

  String get _nomeAtividade => _str('nomeAtividade') ?? '';

  bool get _isPlantio      => _nomeAtividade.toLowerCase().contains('plant');
  bool get _isColheita     => _nomeAtividade.toLowerCase().contains('colheit') &&
      !_nomeAtividade.toLowerCase().contains('destinar');
  bool get _isDestinar     => _nomeAtividade.toLowerCase().contains('destinar');
  bool get _temInsumo      => _str('nomeInsumo') != null;
  bool get _temCultura     => _str('nomeCultura') != null;
  bool get _temPlantioVinculado => _str('culturaPlantio') != null || _dbl('quantidadePlantada') != null;

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Anotação'),
        content: const Text(
          'Tem certeza que deseja excluir esta anotação? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _dao.softDeleteAnotacao(widget.anotacaoId);
      if (mounted) Navigator.pop(context, true);
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_erro != null || _registro == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhe')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(_erro ?? 'Registro não encontrado',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final color = _activityColor(_nomeAtividade);
    final data  = DateTime.tryParse(_str('data_criacao') ?? '') ?? DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // ── header ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => _confirmDelete(),
                tooltip: 'Excluir anotação',
                icon: const Icon(Icons.delete_outline),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.75)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(_activityIcon(_nomeAtividade),
                                  color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _nomeAtividade.isNotEmpty ? _nomeAtividade : 'Anotação',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(data),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── corpo ────────────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Localização — sempre visível
                _Section(
                  title: 'Localização',
                  icon: MdiIcons.mapMarkerRadiusOutline,
                  color: color,
                  children: [
                    _InfoTile(label: 'Local', value: _str('nomeLocal') ?? '—'),
                    _InfoTile(label: 'Área de Cultivo', value: _str('nomeArea') ?? '—'),
                  ],
                ),

                // Cultura — apenas para atividades que envolvem cultura
                if (_temCultura)
                  _Section(
                    title: 'Cultura',
                    icon: MdiIcons.sprout,
                    color: const Color(0xFF22C55E),
                    children: [
                      _InfoTile(label: 'Cultura', value: _str('nomeCultura')!),
                      if (_str('categoriaCltura') != null)
                        _InfoTile(label: 'Categoria', value: _str('categoriaCltura')!),
                    ],
                  ),

                // Dados do Plantio — quando for atividade Plantio
                if (_isPlantio)
                  _Section(
                    title: 'Dados do Plantio',
                    icon: MdiIcons.sprout,
                    color: const Color(0xFF22C55E),
                    children: [
                      _InfoTile(
                        label: 'Quantidade Plantada',
                        value: _fmtQtd(_dbl('quantidade'), _str('unidade_medida')),
                        highlight: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RelatorioRastreabilidadeScreen(
                                    plantioId: widget.anotacaoId,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(MdiIcons.timeline, size: 18),
                            label: const Text('Ver Relatório de Rastreabilidade'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF22C55E),
                              side: const BorderSide(color: Color(0xFF22C55E)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Colheita — quantidade e, se houver, plantio vinculado
                if (_isColheita) ...[
                  _Section(
                    title: 'Dados da Colheita',
                    icon: MdiIcons.barley,
                    color: const Color(0xFFF59E0B),
                    children: [
                      _InfoTile(
                        label: 'Quantidade Colhida',
                        value: _fmtQtd(_dbl('quantidadeColhida'), _str('unidadeColhida')),
                        highlight: true,
                      ),
                    ],
                  ),
                  if (_temPlantioVinculado)
                    _Section(
                      title: 'Plantio de Origem',
                      icon: MdiIcons.timelineClockOutline,
                      color: const Color(0xFF22C55E),
                      children: [
                        if (_str('culturaPlantio') != null)
                          _InfoTile(label: 'Cultura', value: _str('culturaPlantio')!),
                        if (_str('dataPlantio') != null)
                          _InfoTile(
                            label: 'Data do Plantio',
                            value: DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR')
                                .format(DateTime.parse(_str('dataPlantio')!)),
                          ),
                        _InfoTile(
                          label: 'Quantidade Plantada',
                          value: _fmtQtd(_dbl('quantidadePlantada'), _str('unidadePlantada')),
                        ),
                      ],
                    ),
                ],

                // Destinar Colheita — canal + plantio vinculado + quantidade
                if (_isDestinar) ...[
                  _Section(
                    title: 'Escoamento da Produção',
                    icon: MdiIcons.truckDeliveryOutline,
                    color: const Color(0xFFEF4444),
                    children: [
                      _InfoTile(
                        label: 'Canal de Escoamento',
                        value: _str('nomeCanal') ?? '—',
                        highlight: true,
                      ),
                      if (_str('tipoCanal') != null)
                        _InfoTile(label: 'Tipo', value: _str('tipoCanal')!),
                      _InfoTile(
                        label: 'Quantidade Destinada',
                        value: _fmtQtd(_dbl('quantidade'), _str('unidade_medida')),
                      ),
                    ],
                  ),
                  if (_temPlantioVinculado)
                    _Section(
                      title: 'Colheita Vinculada',
                      icon: MdiIcons.barley,
                      color: const Color(0xFFF59E0B),
                      children: [
                        if (_str('culturaPlantio') != null)
                          _InfoTile(label: 'Cultura', value: _str('culturaPlantio')!),
                        if (_str('dataPlantio') != null)
                          _InfoTile(
                            label: 'Data do Plantio',
                            value: DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR')
                                .format(DateTime.parse(_str('dataPlantio')!)),
                          ),
                      ],
                    ),
                ],

                // Insumo — adubação, preparo, plantio, cobertura
                if (_temInsumo)
                  _Section(
                    title: 'Insumo Utilizado',
                    icon: MdiIcons.packageVariantClosed,
                    color: const Color(0xFF78716C),
                    children: [
                      _InfoTile(label: 'Produto', value: _str('nomeInsumo')!),
                      if (_str('fornecedorInsumo') != null)
                        _InfoTile(label: 'Fornecedor', value: _str('fornecedorInsumo')!),
                      _InfoTile(
                        label: 'Quantidade Utilizada',
                        value: _fmtQtd(_dbl('quantidade'), _str('unidade_medida')),
                      ),
                    ],
                  ),

                // Atividades sem campos específicos (Irrigação, Capina, Raleio, Poda...)
                if (!_isPlantio && !_isColheita && !_isDestinar && !_temInsumo)
                  _Section(
                    title: 'Detalhes',
                    icon: MdiIcons.informationOutline,
                    color: color,
                    children: [
                      _InfoTile(
                        label: 'Quantidade',
                        value: _fmtQtd(_dbl('quantidade'), _str('unidade_medida')),
                      ),
                    ],
                  ),

                // Observações — sempre que existir
                if (_str('observacao') != null)
                  _Section(
                    title: 'Observações',
                    icon: MdiIcons.noteTextOutline,
                    color: Colors.blueGrey,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Text(
                          _str('observacao')!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade800,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}






// ─── widgets internos ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.icon,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _InfoTile({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: highlight ? AppTheme.primaryGreen : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}