import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/components/app_drawer/app_drawer.dart';
import 'package:fast_feet_app/components/custom_text_field.dart';
import 'package:fast_feet_app/components/order_item.dart';
import 'package:fast_feet_app/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isDirtyField = false;

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrdersProvider>(context, listen: false).loadOrders();
  }

  Future<void> filterOrders() async {
    if (_searchController.text.isEmpty) return;

    await Provider.of<OrdersProvider>(context, listen: false).loadOrders(
      search: _searchController.text,
    );
  }

  Future<void> clearFilter() async {
    _searchController.clear();
    await Provider.of<OrdersProvider>(context, listen: false).loadOrders(
      status: OrderStatus.disponivelRetirada,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrdersProvider>(context, listen: false).loadOrders();
    });

    _searchController.addListener(_handleDirtyField);
  }

  void _handleDirtyField() {
    print(
      'text controller: ${_searchController.text}',
    );
    if (_searchController.text.isNotEmpty) {
      setState(() => _isDirtyField = true);
    } else {
      setState(() => _isDirtyField = false);
    }
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
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Pedidos',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        color: AppColors.purple,
        onRefresh: () => _refreshOrders(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Filtrar por bairro',
                suffixIcon: IconButton(
                  onPressed: _isDirtyField
                      ? () async {
                          await clearFilter();
                        }
                      : null,
                  icon: _isDirtyField
                      ? Icon(PhosphorIconsRegular.xCircle)
                      : Icon(PhosphorIconsRegular.magnifyingGlass),
                ),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) async {
                  await filterOrders();
                },
              ),
              const SizedBox(height: 10),
              Consumer<OrdersProvider>(
                builder: (ctx, ordersProvider, child) {
                  if (ordersProvider.isLoading) {
                    return Expanded(
                      child: const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.purple),
                      ),
                    );
                  }
                  if (ordersProvider.items.isEmpty) {
                    return Expanded(
                      child: const Center(
                        child: Text('Não há encomendas para mostrar'),
                      ),
                    );
                  }
                  return Expanded(
                    child: Column(
                      children: [
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
                            itemBuilder: (ctx, index) {
                              return OrderItem(
                                  order: ordersProvider.items[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
