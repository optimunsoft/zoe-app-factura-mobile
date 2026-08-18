import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_flutter/modules/third-party/store/common.store.dart';
import 'package:hello_flutter/modules/third-party/store/thirdparty.store.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/app_navigator.dart';
import 'core/auth/auth_controller.dart';
import 'core/config/app_env.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/host_tema_app.dart';
import 'core/theme/tema_app_store.dart';
import 'data/pos_controller.dart';
import 'modules/categories/store/categories.store.dart';
import 'modules/method_payments/store/method_payments.store.dart';
import 'modules/products/store/products.store.dart';
import 'modules/sales/store/sales.store.dart';
import 'modules/sales/store/sales_history.store.dart';
import 'modules/taxes/store/taxes.store.dart';
import 'presentation/pages/inicio_sesion/inicio_sesion_page.dart';
import 'presentation/pages/navegacion_principal/navegacion_principal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  AppEnv.init();

  await initializeDateFormatting('es');

  final temaApp = TemaAppStore();
  await temaApp.cargar();

  runApp(TiendaATiendaApp(temaApp: temaApp));
}

class TiendaATiendaApp extends StatelessWidget {
  const TiendaATiendaApp({super.key, required this.temaApp});

  final TemaAppStore temaApp;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: temaApp),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PosController()),
        ChangeNotifierProvider(create: (_) => ThirdPartyStore()),
        ChangeNotifierProvider(create: (_) => CommonStore()),
        ChangeNotifierProvider(create: (_) => CategoriesStore()),
        ChangeNotifierProvider(create: (_) => ProductsStore()),
        ChangeNotifierProvider(create: (_) => MethodPaymentsStore()),
        ChangeNotifierProvider(create: (_) => SalesStore()),
        ChangeNotifierProvider(create: (_) => SalesHistoryStore()),
        ChangeNotifierProvider(create: (_) => TaxesStore()),
      ],
      child: Consumer<TemaAppStore>(
        builder: (context, tema, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tienda a Tienda POS',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: tema.oscuro ? ThemeMode.dark : ThemeMode.light,
            themeAnimationDuration: Duration.zero,
            navigatorKey: appNavigatorKey,
            builder: (context, child) {
              return HostTemaApp(
                child: FToastBuilder()(context, child),
              );
            },
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
          );
        },
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthController>().isLoggedIn;
    if (!isLoggedIn) {
      return const InicioSesionPage();
    }
    return const NavegacionPrincipal();
  }
}
