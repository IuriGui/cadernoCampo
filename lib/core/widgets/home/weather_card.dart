import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/clima_info.dart';
import '../../provider/home_provider.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(provider.cidadeEstado),
        const SizedBox(height: 16),
        _buildBody(provider.isLoading, provider.clima),
      ],
    );
  }

  Widget _buildHeader(String? cidadeEstado) {
    final localizacao = (cidadeEstado != null )
        ? cidadeEstado
        : 'Localização desconhecida';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Previsão do tempo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.green, size: 18),
            const SizedBox(width: 4),
            Text(
              localizacao,
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(bool isLoading, ClimaInfo? clima) {
    if (isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (clima == null) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_outlined, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Clima indisponível',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildMainInfo(clima),
        const SizedBox(height: 24),
        _buildDetails(clima),
      ],
    );
  }

  Widget _buildMainInfo(ClimaInfo clima) {
    return Row(
      children: [
        const Icon(Icons.wb_cloudy_outlined, size: 80, color: Colors.blueGrey),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${clima.tempMin.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('/', style: TextStyle(fontSize: 32, color: Colors.grey)),
                  ),
                  Text(
                    '${clima.tempMax.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Text('mín.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 40),
                  Text('máx.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${clima.precipitacaoProbabilidade.toStringAsFixed(0)}% de chance de chuva',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(ClimaInfo clima) {
    return Column(
      children: [
        Row(
          children: [
            _buildDetailItem(
              icon: Icons.cloud_queue,
              color: Colors.blue,
              label: 'Chuva',
              value: '${clima.precipitacaoProbabilidade.toStringAsFixed(0)}%',
              sub: '(${clima.precipitacao.toStringAsFixed(1)} mm)',
            ),
            const Spacer(),
            _buildDetailItem(
              icon: Icons.water_drop_outlined,
              color: Colors.blue,
              label: 'Umidade',
              value: '${clima.umidade.toStringAsFixed(0)}%',
              sub: 'do ar',
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildDetailItem(
              icon: Icons.air,
              color: Colors.green,
              label: 'Vento',
              value: '${clima.velocidadeVento.toStringAsFixed(0)} km/h',
              sub: clima.direcaoVento,
              valueColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required String sub,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16, color: valueColor)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}