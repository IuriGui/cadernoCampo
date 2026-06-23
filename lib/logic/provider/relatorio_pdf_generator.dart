import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../data/models/evento_rastreabilidade.dart';


class RelatorioPdfGenerator {
  static Future<void> gerarECompartilhar(RelatorioRastreabilidade r) async {
    final doc = pw.Document();
    final formatoData = DateFormat('dd/MM/yyyy');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (_) => pw.Text(
          'Relatório de Rastreabilidade',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        build: (context) => [
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#E8F5E9'),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(r.nomeCultura ?? 'Cultura não informada',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('${r.nomeArea} - ${r.nomeLocal}'),
                pw.SizedBox(height: 6),
                pw.Text('Plantado em: ${formatoData.format(r.dataPlantio)}'),
                pw.Text('Quantidade plantada: ${r.quantidadePlantada} ${r.unidadeMedida ?? ''}'),
                pw.Text('Status: ${r.foiColhido ? 'Colhido' : 'Em andamento'}'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('LINHA DO TEMPO', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(70),
              1: const pw.FixedColumnWidth(110),
              2: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _celula('Data', negrito: true),
                  _celula('Atividade', negrito: true),
                  _celula('Detalhes', negrito: true),
                ],
              ),
              ...r.eventos.map((evento) => pw.TableRow(
                children: [
                  _celula(formatoData.format(evento.data)),
                  _celula(evento.nomeAtividade),
                  _celula(
                    [evento.descricaoResumida, evento.observacao]
                        .where((s) => s != null && s.isNotEmpty)
                        .join(' — '),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'rastreabilidade_plantio_${r.plantioId}.pdf',
    );
  }

  static pw.Widget _celula(String texto, {bool negrito = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        texto,
        style: pw.TextStyle(fontSize: 10, fontWeight: negrito ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }
}