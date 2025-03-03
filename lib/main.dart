import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/providers/orders_provider.dart';
import 'package:fast_feet_app/providers/user_provider.dart';
import 'package:fast_feet_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('pt_BR', null);

  Animate.restartOnHotReload = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'Fast Feet',
        debugShowCheckedModeBanner: false,
        theme: lightModeTheme,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initialRoute,
        navigatorKey: AppRoutes.navigatorKey,
      ),
    );
  }
}
