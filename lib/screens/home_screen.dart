import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:fast_feet_app/services/auth_service.dart';
import 'package:fast_feet_app/providers/user_provider.dart';
import 'package:fast_feet_app/screens/pending_orders_screen.dart';
import 'package:fast_feet_app/screens/available_orders_screen.dart';
import 'package:fast_feet_app/screens/completed_orders_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: AppColors.purple,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          'Entregas',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIcons.signOut(),
              color: Colors.white,
            ),
            onPressed: () async {
              final authService = AuthService();

              await userProvider.logout();
              await authService.removeToken();

              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeletonizer(
                  enabled: !userProvider.isAuthenticated,
                  ignoreContainers: true,
                  effect: ShimmerEffect(
                    baseColor: Colors.black54,
                    highlightColor: AppColors.textBase,
                    duration: Duration(milliseconds: 1000),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bem vindo,',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        userProvider.user != null
                            ? userProvider.user!.name
                            : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      PhosphorIconsFill.mapPin,
                      color: AppColors.yellow,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Manaus - AM',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: <Widget>[
          AvailableOrdersScreen(),
          PendingOrdersScreen(),
          CompletedOrders(),
        ][_currentScreenIndex],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentScreenIndex,
        onDestinationSelected: (index) {
          setState(() => _currentScreenIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(PhosphorIconsFill.boxArrowUp),
            label: 'Disponíveis',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsFill.clockCountdown),
            label: 'Pendentes',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsFill.checkFat),
            label: 'Concluídas',
          ),
        ],
      ),
    );
  }
}
