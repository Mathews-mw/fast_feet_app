import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/components/custom_text_field.dart';
import 'package:fast_feet_app/components/order_item.dart';
import 'package:fast_feet_app/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class AvailableOrdersScreen extends StatefulWidget {
  const AvailableOrdersScreen({super.key});

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  TextEditingController _searchController = TextEditingController();

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrdersProvider>(context, listen: false)
        .loadOrders(status: OrderStatus.disponivelRetirada);
  }

  Future<void> filterOrders() async {
    print('search input: ${_searchController.text}');
    if (_searchController.text.isEmpty) return;

    return Provider.of<OrdersProvider>(context, listen: false).loadOrders(
      status: OrderStatus.disponivelRetirada,
      search: _searchController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: RefreshIndicator(
        color: AppColors.purple,
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Filtrar por bairro',
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  await filterOrders();
                                },
                                icon:
                                    Icon(PhosphorIconsRegular.magnifyingGlass)),
                            controller: _searchController,
                            onChanged: (value) {
                              print('search input value: $value');
                              _searchController.text = value;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) async {
                              print('input value on submitted: $value');
                              await filterOrders();
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  endIndent: 15,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              Text(
                                '${ordersProvider.items.length} entregas',
                                style: TextStyle(color: AppColors.textLight),
                              ),
                              Expanded(
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  indent: 15,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              itemCount: ordersProvider.items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (ctx, i) {
                                return OrderItem(
                                    order: ordersProvider.items[i]);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
