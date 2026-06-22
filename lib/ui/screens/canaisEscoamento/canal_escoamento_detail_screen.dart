import 'package:caderno_de_campo/data/dao/anotacao_dao.dart';
import 'package:caderno_de_campo/data/models/canal.dart';
import 'package:caderno_de_campo/ui/screens/activity/anotacoes_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../data/database/app_database.dart';
import '../../../data/models/anotacao.dart';

class CanalEscoamentoDetailScreen extends StatefulWidget {
  final CanalEscoamento escoamento;

  const CanalEscoamentoDetailScreen({
    super.key,
    required this.escoamento,
  });

  @override
  State<CanalEscoamentoDetailScreen> createState() =>
      _CanalEscoamentoDetailScreenState();
}

class _CanalEscoamentoDetailScreenState
    extends State<CanalEscoamentoDetailScreen> {
  final AnotacaoDAO _anotacaoDAO = AnotacaoDAO();

  List<Map<String, dynamic>> anotacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnotacoes();
    print('===== Printando id do canal -======');
    print(widget.escoamento.id);
    print('==========================');
    print(anotacoes.length);
  }

  Future<void> _loadAnotacoes() async {
    final results =
    await _anotacaoDAO.getAnotacoesByCanal(widget.escoamento.id!);

    setState(() {
      anotacoes = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.escoamento.nome),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : anotacoes.isEmpty
            ? const Center(
          child: Text('Nenhuma anotação encontrada'),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.escoamento.nome,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo: ${widget.escoamento.tipo}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Anotações',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: anotacoes.length,
                itemBuilder: (context, index) {
                  final anotacao = anotacoes[index];

                  final data = DateTime.parse(
                      anotacao['data_criacao']
                  );

                  return Card(
                    child: ListTile(
                      leading: Icon(MdiIcons.truckDelivery),
                      title: Text(
                        (anotacao['nome_cultura'] as String?) ??
                            'Cultura não definida',
                      ),
                      // TODO Implementar o botão de detalhes
                      onTap: () async{
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnotacoesDetailScreen(anotacaoId: anotacao['id'],)
                          ),
                        );
                      },
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(
                            anotacao['data_criacao'],
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chevron_right, color: Colors.black), onPressed: () {  },
                      )
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
