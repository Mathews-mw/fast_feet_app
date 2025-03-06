import 'package:fast_feet_app/screens/create_new_recipient_screen.dart';
import 'package:fast_feet_app/screens/create_order.dart';
import 'package:fast_feet_app/screens/delivery_order_screen.dart';
import 'package:fast_feet_app/screens/opening_screen.dart';
import 'package:fast_feet_app/screens/login_screen.dart';
import 'package:fast_feet_app/screens/orders_screen.dart';
import 'package:fast_feet_app/screens/recipients_screen.dart';
import 'package:flutter/material.dart';

import 'package:fast_feet_app/screens/home_screen.dart';
import 'package:fast_feet_app/screens/order_details_screen.dart';

class AppRoutes {
  static const opening = '/';
  static const home = '/home';
  static const login = '/login';
  static const orderDetails = '/order-details';
  static const deliveryOrder = '/delivery-order';
  static const orders = '/orders';
  static const createOrder = '/create-order';
  static const recipients = '/recipients';
  static const newRecipientForm = '/recipients/new';

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    AppRoutes.opening: (ctx) => const OpeningScreen(),
    AppRoutes.home: (ctx) => const HomeScreen(),
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.orderDetails: (ctx) => const OrderDetailsScreen(),
    AppRoutes.deliveryOrder: (ctx) => const DeliveryOrderScreen(),
    AppRoutes.orders: (ctx) => const OrdersScreen(),
    AppRoutes.createOrder: (ctx) => const CreateOrder(),
    AppRoutes.recipients: (ctx) => const RecipientsScreen(),
    AppRoutes.newRecipientForm: (ctx) => const CreateNewRecipientScreen(),
  };

  static String initialRoute = AppRoutes.opening;

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
