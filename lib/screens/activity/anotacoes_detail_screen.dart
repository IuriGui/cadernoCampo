import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/models/anotacao.dart';
import '../../core/theme/app_theme.dart';

Color _activityColor(String? nome) {
  final n = nome?.toLowerCase() ?? '';
  if (n.contains('colheit')) return const Color(0xFFF59E0B);
  if (n.contains('plant')) return const Color(0xFF22C55E);
  if (n.contains('irrig')) return const Color(0xFF3B82F6);
  if (n.contains('adub') || n.contains('nutri')) return const Color(0xFF14B8A6);
  if (n.contains('preparo') || n.contains('solo')) return const Color(0xFF92400E);
  if (n.contains('poda')) return const Color(0xFFEC4899);
  return AppTheme.primaryGreen;
}

IconData _activityIcon(String? nome) {
  final n = nome?.toLowerCase() ?? '';
  if (n.contains('colheit')) return MdiIcons.barley;
  if (n.contains('plant')) return MdiIcons.sprout;
  if (n.contains('irrig')) return MdiIcons.waterPump;
  if (n.contains('adub') || n.contains('nutri')) return MdiIcons.flask;
  if (n.contains('preparo') || n.contains('solo')) return MdiIcons.shovel;
  if (n.contains('poda')) return MdiIcons.scissorsCutting;
  return MdiIcons.clipboardTextOutline;
}

class AnotacoesDetailScreen extends StatelessWidget {
  final Anotacao registro;

  const AnotacoesDetailScreen({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    final color = _activityColor(registro.nomeAtividade);
    final isColheita = registro.nomeDestino != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color.withOpacity(0.8)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                _activityIcon(registro.nomeAtividade),
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    registro.nomeAtividade ?? 'Anotação',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    DateFormat("d 'de' MMMM, yyyy", 'pt_BR').format(registro.dataCriacao),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
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

          SliverList(
            delegate: SliverChildListDelegate([
              _buildSection(
                title: 'Local da Atividade',
                icon: MdiIcons.mapMarkerRadiusOutline,
                color: color,
                child: Column(
                  children: [
                    _buildInfoTile('Propriedade/Local', registro.nomeLocal ?? '—'),
                    _buildDivider(),
                    _buildInfoTile('Área de Cultivo', registro.nomeArea ?? '—'),
                  ],
                ),
              ),
              
              _buildSection(
                title: 'Detalhes Técnicos',
                icon: MdiIcons.informationOutline,
                color: color,
                child: Column(
                  children: [
                    _buildInfoTile('Cultura', registro.nomeCultura ?? 'Não informada'),
                    _buildDivider(),
                    _buildInfoTile(
                      'Quantidade', 
                      registro.quantidade % 1 == 0
                        ? '${registro.quantidade.toInt()} ${registro.unidadeMedida ?? ''}'
                        : '${registro.quantidade} ${registro.unidadeMedida ?? ''}'
                    ),
                  ],
                ),
              ),

              if (registro.nomeInsumo != null)
                _buildSection(
                  title: 'Insumo Utilizado',
                  icon: MdiIcons.packageVariantClosed,
                  color: Colors.brown,
                  child: _buildInfoTile('Produto', registro.nomeInsumo!),
                ),

              if (isColheita)
                _buildSection(
                  title: 'Dados da Colheita',
                  icon: MdiIcons.truckDeliveryOutline,
                  color: Colors.orange,
                  child: _buildInfoTile('Destino da Produção', registro.nomeDestino!, isHighlight: true),
                ),

              if (registro.observacao != null && registro.observacao!.isNotEmpty)
                _buildSection(
                  title: 'Observações Complementares',
                  icon: MdiIcons.noteTextOutline,
                  color: Colors.blueGrey,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      registro.observacao!,
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.5),
                    ),
                  ),
                ),
              
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required Color color, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isHighlight ? AppTheme.primaryGreen : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.grey.shade100, indent: 16, endIndent: 16);
}