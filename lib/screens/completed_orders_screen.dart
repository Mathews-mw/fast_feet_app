import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/components/order_item.dart';
import 'package:fast_feet_app/providers/orders_provider.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({super.key});

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrdersProvider>(context, listen: false)
        .loadOrders(status: OrderStatus.entregue);
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
              .loadUserOrders(status: OrderStatus.entregue),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Consumer<OrdersProvider>(
                  child: const Center(
                    child: Text('Não há encomendas para mostrar'),
                  ),
                  builder: (ctx, ordersProvider, child) {
                    if (ordersProvider.userOrders.isEmpty) {
                      return child!;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.separated(
                        itemCount: ordersProvider.userOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          return OrderItem(order: ordersProvider.userOrders[i]);
                        },
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
