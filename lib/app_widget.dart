import 'package:caderno_de_campo/data/repositories/auth_repository.dart';
import 'package:caderno_de_campo/data/services/local/anotacao_service.dart';
import 'package:caderno_de_campo/data/services/local/local_service.dart';
import 'package:caderno_de_campo/data/services/local/produtor_service.dart';
import 'package:caderno_de_campo/data/services/local/propriedade_service.dart';
import 'package:caderno_de_campo/data/services/local/usuario_service.dart';
import 'package:caderno_de_campo/ui/auth/login/login_screen.dart';
import 'package:caderno_de_campo/ui/auth/login/login_viewmodel.dart';
import 'package:caderno_de_campo/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/repositories/anotacao_repository.dart';
import 'data/repositories/local_repository.dart';
import 'data/repositories/produtor_repository.dart';
import 'data/repositories/propriedade_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => UsuarioService()),
        Provider(create: (_) => ProdutorService()),
        Provider(create: (_) => PropriedadeService()),
        Provider(create: (ctx) => LocalService()),
        Provider(create: (ctx) => AnotacaoService()),
        Provider(create: (ctx) => AuthRepository(ctx.read(), ctx.read())),
        Provider(create: (ctx) => PropriedadeRepository(ctx.read())),
        Provider(create: (ctx) => LocalRepository(ctx.read(), ctx.read())),
        Provider(create: (ctx) => AnotacaoRepository(ctx.read())),
        Provider(create: (ctx) => ProdutorRepository(ctx.read())),
        ChangeNotifierProvider(create: (ctx) => LoginViewModel(ctx.read())),
      ],
      child: MaterialApp(
        title: 'Caderno de Campo',
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        locale: const Locale('pt', 'BR'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}