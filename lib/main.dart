import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/config/app_env.dart';
import 'core/theme/app_theme.dart';
import 'data/pos_controller.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await dotenv.load(fileName: '.env');
  AppEnv.init();

  await initializeDateFormatting('es');

  runApp(const TiendaATiendaApp());
}

class TiendaATiendaApp extends StatelessWidget {
  const TiendaATiendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tienda a Tienda POS',
        theme: AppTheme.light,
        locale: const Locale('es', 'MX'),
        supportedLocales: const [
          Locale('es', 'MX'),
          Locale('es'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) {
      return ZoeRippleLoginPage(
        onSuccess: () => setState(() => _loggedIn = true),
      );
    }
    return const MainShell();
  }
}
