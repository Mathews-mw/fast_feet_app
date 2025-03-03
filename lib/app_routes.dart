import 'package:fast_feet_app/screens/delivery_order_screen.dart';
import 'package:fast_feet_app/screens/opening_screen.dart';
import 'package:fast_feet_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:fast_feet_app/screens/home_screen.dart';
import 'package:fast_feet_app/screens/order_details_screen.dart';

class AppRoutes {
  static const opening = '/';
  static const home = '/home';
  static const login = '/login';
  static const orderDetails = '/order-details';
  static const deliveryOrder = '/delivery-order';

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    AppRoutes.opening: (ctx) => const OpeningScreen(),
    AppRoutes.home: (ctx) => const HomeScreen(),
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.orderDetails: (ctx) => const OrderDetailsScreen(),
    AppRoutes.deliveryOrder: (ctx) => const DeliveryOrderScreen(),
  };

  static String initialRoute = AppRoutes.opening;

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
