import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/dao/propriedade_dao.dart';
import '../../core/models/propriedade.dart';
import '../../core/models/user.dart';
import 'edit_propriedade_screen.dart';

class PropriedadeScreen extends StatefulWidget {
  final User user;
  const PropriedadeScreen({super.key, required this.user});

  @override
  State<PropriedadeScreen> createState() => _PropriedadeScreenState();
}

class _PropriedadeScreenState extends State<PropriedadeScreen> {
  final PropriedadeDAO _propriedadeDAO = PropriedadeDAO();
  late Future<Propriedade?> _propriedadeFuture;

  @override
  void initState() {
    super.initState();
    _refreshPropriedade();
  }

  void _refreshPropriedade() {
    setState(() {
      _propriedadeFuture = _propriedadeDAO.getPropriedadeByUsuario(widget.user.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // No novo esquema, o papel está em produtor_propriedade. 
    // Por enquanto, permitiremos edição para todos os usuários logados.
    const bool isProprietario = true; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Propriedade'),
      ),
      body: FutureBuilder<Propriedade?>(
        future: _propriedadeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }
          
          final propriedade = snapshot.data;
          if (propriedade == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Nenhuma propriedade cadastrada ainda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(MdiIcons.hoopHouse, size: 80, color: const Color(0xFF2E7D32)),
                      const SizedBox(height: 16),
                      Text(
                        propriedade.nome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        '${propriedade.cidade} - ${propriedade.estado}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Informações de Localização'),
                _buildInfoCard([
                  _buildInfoRow(MdiIcons.mapMarkerOutline, 'Cidade', propriedade.cidade),
                  _buildInfoRow(MdiIcons.mapOutline, 'Estado', propriedade.estado),
                  _buildInfoRow(MdiIcons.mailboxOutline, 'CEP', propriedade.cep),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle('Áreas e Dimensões'),
                _buildInfoCard([
                  _buildInfoRow(MdiIcons.rulerSquare, 'Área Total', '${propriedade.areaTotal} ha'),
                  _buildInfoRow(MdiIcons.checkCircleOutline, 'Área Própria', '${propriedade.areaPropria} ha'),
                  if (propriedade.areaArrendada != null)
                    _buildInfoRow(MdiIcons.handshakeOutline, 'Área Arrendada', '${propriedade.areaArrendada} ha'),
                  if (propriedade.areaProducaoVegetal != null)
                    _buildInfoRow(MdiIcons.sproutOutline, 'Produção Vegetal', '${propriedade.areaProducaoVegetal} ha'),
                ]),
                if (propriedade.observacao != null && propriedade.observacao!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Observações'),
                  _buildInfoCard([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        propriedade.observacao!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ]),
                ],
                const SizedBox(height: 40),
                if (isProprietario)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPropriedadeScreen(propriedade: propriedade),
                          ),
                        );
                        if (result == true) {
                          _refreshPropriedade();
                        }
                      },
                      icon: Icon(MdiIcons.pencilOutline),
                      label: const Text('Editar Informações'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
