import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/models/anotacao.dart';

class AtividadesDetailScreen extends StatelessWidget {
  final Anotacao registro;

  const AtividadesDetailScreen({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Atividade'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSectionTitle('Informações Gerais'),
              _buildInfoTile(
                icon: Icons.calendar_today,
                label: 'Data da Ocorrência',
                value: DateFormat('dd/MM/yyyy').format(registro.dataCriacao),
              ),
              _buildInfoTile(
                icon: MdiIcons.sprout,
                label: 'Cultura',
                value: registro.nomeCultura ?? 'Não informado',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Localização'),
              _buildInfoTile(
                icon: Icons.location_on_outlined,
                label: 'Local',
                value: registro.nomeLocal ?? 'Não informado',
              ),
              _buildInfoTile(
                icon: MdiIcons.mapMarkerRadius,
                label: 'Área de Cultivo',
                value: registro.nomeArea ?? 'Não informado',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Insumos e Detalhes'),
              _buildInfoTile(
                icon: MdiIcons.packageVariantClosed,
                label: 'Insumo',
                value: registro.nomeInsumo ?? 'Nenhum',
              ),
              _buildInfoTile(
                icon: MdiIcons.weight,
                label: 'Quantidade',
                value: '${registro.quantidade} ${registro.unidadeMedida ?? ''}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            registro.nomeAtividade ?? 'Atividade',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4)
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
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
