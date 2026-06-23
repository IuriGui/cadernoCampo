import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/dao/rastreabilidade_dao.dart';
import '../../../data/models/evento_rastreabilidade.dart';
import '../../../logic/provider/relatorio_pdf_generator.dart';


class RelatorioRastreabilidadeScreen extends StatefulWidget {
  final int plantioId;

  const RelatorioRastreabilidadeScreen({super.key, required this.plantioId});

  @override
  State<RelatorioRastreabilidadeScreen> createState() => _RelatorioRastreabilidadeScreenState();
}

class _RelatorioRastreabilidadeScreenState extends State<RelatorioRastreabilidadeScreen> {
  late Future<RelatorioRastreabilidade> _future;
  bool _gerandoPdf = false;

  @override
  void initState() {
    super.initState();
    _future = RastreabilidadeDao().getRelatorioRastreabilidade(widget.plantioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rastreabilidade do Plantio')),
      body: FutureBuilder<RelatorioRastreabilidade>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar relatório: ${snapshot.error}'));
          }

          final relatorio = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(relatorio),
                    const SizedBox(height: 24),
                    const Text(
                      'LINHA DO TEMPO',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey, fontSize: 12, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 12),
                    ...relatorio.eventos.asMap().entries.map((entry) {
                      final isLast = entry.key == relatorio.eventos.length - 1;
                      return _buildTimelineItem(entry.value, isLast);
                    }),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _gerandoPdf ? null : () => _exportarPdf(relatorio),
                      icon: _gerandoPdf
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.picture_as_pdf),
                      label: Text(_gerandoPdf ? 'Gerando...' : 'Exportar PDF'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(RelatorioRastreabilidade r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(r.nomeCultura ?? 'Cultura não informada',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${r.nomeArea} • ${r.nomeLocal}', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          Text('Plantado em ${DateFormat('dd/MM/yyyy').format(r.dataPlantio)}'),
          Text('Quantidade plantada: ${r.quantidadePlantada} ${r.unidadeMedida ?? ''}'),
          const SizedBox(height: 4),
          Chip(
            label: Text(r.foiColhido ? 'Colhido' : 'Em andamento'),
            backgroundColor: r.foiColhido ? Colors.green.shade100 : Colors.orange.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(EventoRastreabilidade evento, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(evento.data),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  Text(evento.nomeAtividade, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (evento.descricaoResumida.isNotEmpty)
                    Text(evento.descricaoResumida, style: const TextStyle(fontSize: 13)),
                  if (evento.observacao != null && evento.observacao!.isNotEmpty)
                    Text(evento.observacao!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportarPdf(RelatorioRastreabilidade relatorio) async {
    setState(() => _gerandoPdf = true);
    try {
      await RelatorioPdfGenerator.gerarECompartilhar(relatorio);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao gerar PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _gerandoPdf = false);
    }
  }
}