import 'package:flutter/material.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/authentication/auth_service.dart';
import '../../core/models/user.dart';
import '../../core/models/propriedade.dart';
import '../../core/models/produtor.dart';
import '../../core/dao/propriedade_dao.dart';
import '../../core/dao/produtor_dao.dart';
import 'login_screen.dart';

class RegisterProducerScreen extends StatefulWidget {
  final Map<String, String> userData;
  final Map<String, String> propertyData;

  const RegisterProducerScreen({
    super.key,
    required this.userData,
    required this.propertyData,
  });

  @override
  State<RegisterProducerScreen> createState() => _RegisterProducerScreenState();
}

class _RegisterProducerScreenState extends State<RegisterProducerScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  String _mecanismo = 'OCS';
  bool _isLoading = false;

  final List<String> _programas = ['PNAE', 'PAA', 'Feira Local', 'Exportação'];
  final Map<String, bool> _selecionados = {};

  @override
  void initState() {
    super.initState();
    for (var p in _programas) {
      _selecionados[p] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Produtor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produtor *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v == null || v.isEmpty ? '* Obrigatório' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                "Mecanismo de Controle:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: _mecanismo,
                onChanged: (v) => setState(() => _mecanismo = v!),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('OCS'),
                        value: 'OCS',
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('SPG'),
                        value: 'SPG',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Programas e Comercialização:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ..._programas.map((p) => CheckboxListTile(
                    title: Text(p),
                    value: _selecionados[p],
                    onChanged: (v) => setState(() => _selecionados[p] = v!),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Finalizar Cadastro',
                isLoading: _isLoading,
                onPressed: _finishRegistration,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        // 1. Cadastrar Usuário
        final user = User(
          name: widget.userData['name']!,
          email: widget.userData['email']!,
          password: widget.userData['password']!,
          papel: widget.userData['papel']!,
        );
        
        final success = await AuthService().register(user);
        
        if (success) {
          // Precisamos pegar o ID do usuário recém criado
          // Para simplificar no SQLite sem auth real, vamos buscar pelo email
          final dbUser = await AuthService().login(user.email, user.password);
          
          if (dbUser != null && dbUser.id != null) {
            // 2. Cadastrar Propriedade vinculada ao Usuário
            final propriedade = Propriedade(
              usuarioId: dbUser.id!,
              nome: widget.propertyData['nome']!,
              municipio: widget.propertyData['municipio']!,
              cep: widget.propertyData['cep'] ?? '',
              estado: widget.propertyData['estado']!,
              areaTotal: double.tryParse(widget.propertyData['areaTotal']!) ?? 0,
            );
            await PropriedadeDAO().insertPropriedade(propriedade);

            // 3. Cadastrar Produtor
            final produtor = Produtor(
              nome: nomeController.text.trim(),
              mecanismoControle: _mecanismo == 'OCS' ? MecanismoControle.ocs : MecanismoControle.spg,
            );
            final produtorId = await ProdutorDAO().insertProdutor(produtor);

            // 4. Vincular Programas (Seeding de programas assume IDs fixos 1, 2, 3, 4)
            // Na vida real você buscaria os IDs, aqui vamos mapear os nomes aos IDs do seed
            final mapaProgramas = {'PNAE': 1, 'PAA': 2, 'Feira Local': 3, 'Exportação': 4};
            for (var entry in _selecionados.entries) {
              if (entry.value && mapaProgramas.containsKey(entry.key)) {
                await ProdutorDAO().linkProgramaProdutor(produtorId, mapaProgramas[entry.key]!);
              }
            }
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cadastro completo realizado com sucesso!')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao cadastrar usuário.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ocorreu um erro: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
