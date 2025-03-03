import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/components/order_item.dart';
import 'package:fast_feet_app/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class AvailableOrdersScreen extends StatefulWidget {
  const AvailableOrdersScreen({super.key});

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrdersProvider>(context, listen: false)
        .loadOrders(status: OrderStatus.disponivelRetirada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
          future: Provider.of<OrdersProvider>(context)
              .loadOrders(status: OrderStatus.disponivelRetirada),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.purple,
                  ),
                )
              : Consumer<OrdersProvider>(
                  child: const Center(
                    child: Text('Não há encomendas para mostrar'),
                  ),
                  builder: (ctx, ordersProvider, child) {
                    if (ordersProvider.items.isEmpty) {
                      return child!;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.separated(
                        itemCount: ordersProvider.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          return OrderItem(order: ordersProvider.items[i]);
                        },
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
