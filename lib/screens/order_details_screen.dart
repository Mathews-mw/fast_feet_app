import 'package:fast_feet_app/@exceptions/api_exceptions.dart';
import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/components/loading_overlay.dart';
import 'package:fast_feet_app/components/pickup_order_overlay.dart';
import 'package:fast_feet_app/providers/orders_provider.dart';
import 'package:fast_feet_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_feet_app/models/order.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Order? _order;
  late Future<void> _orderFuture;
  bool _isLoading = false;
  bool _isSuccessPickup = false;

  Future<void> _loadOrderDetails({
    required BuildContext context,
    required String orderId,
  }) async {
    final order = await Provider.of<OrdersProvider>(context, listen: false)
        .getOrderById(orderId);

    setState(() {
      _order = order;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    final String orderId = ModalRoute.of(context)!.settings.arguments as String;
    _orderFuture = _loadOrderDetails(context: context, orderId: orderId);
  }

  Future<void> pickupOrder(String orderId) async {
    setState(() => _isLoading = true);
    setState(() => _isSuccessPickup = false);

    try {
      await Provider.of<OrdersProvider>(context, listen: false)
          .pickupOrder(orderId);

      setState(() => _isLoading = false);
      setState(() => _isSuccessPickup = true);
    } on ApiExceptions catch (err) {
      setState(() => _isLoading = false);
      setState(() => _isSuccessPickup = false);
      await _errorMessageAlert(
        'Ocorreu um erro ao tentar retirar o pacote!',
        err.message,
      );
    } catch (err) {
      setState(() => _isLoading = false);
      setState(() => _isSuccessPickup = false);
      await _errorMessageAlert(
        'Ocorreu um erro ao tentar retirar o pacote!',
        'Aconteceu um error inesperado ao tentar fazer a retirada do pacote. Por favor, tente novamente.',
      );
    }
  }

  Future<void> _errorMessageAlert(String title, String message) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String orderId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Detalhes',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              _order == null) {
            return Center(
              child: Text(
                'Ordem $orderId não encontrada!',
                textAlign: TextAlign.center,
              ),
            );
          }

          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        PhosphorIconsFill.clipboardText,
                                        color: AppColors.yellow,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Dados',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'DESTINATÁRIO',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(_order!.recipient.name),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ENDEREÇO',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(
                                        '${_order!.recipient.street}, ${_order!.recipient.number}',
                                      ),
                                      if (_order!.recipient.complement != null)
                                        Text(_order!.recipient.complement!),
                                      Text(_order!.recipient.district!),
                                      Text(
                                        '${_order!.recipient.city}, ${_order!.recipient.state}',
                                      ),
                                      Text(_order!.recipient.formattedCep)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        PhosphorIconsFill.info,
                                        color: AppColors.yellow,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Situação',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'STATUS',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              Text(_order!.statusText),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'DATA DE RETIRADA',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              Text(
                                                _order!.withdrawalAt != null
                                                    ? DateFormat('dd/MM/yy')
                                                        .format(_order!
                                                            .withdrawalAt!)
                                                    : '--/--/----',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'POSTADO EM',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yy')
                                                    .format(_order!.postedAt),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'DATA DA ENTREGA',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              Text(
                                                _order!.deliveryAt != null
                                                    ? DateFormat('dd/MM/yy')
                                                        .format(
                                                            _order!.deliveryAt!)
                                                    : '--/--/----',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_order!.status == OrderStatus.disponivelRetirada)
                            ElevatedButton(
                              child: const Text('Retirar Pacote'),
                              onPressed: () => pickupOrder(orderId),
                            ),
                          if (_order!.status == OrderStatus.rotaEntrega)
                            ElevatedButton(
                              child: const Text('Confirmar entrega'),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.deliveryOrder,
                                  arguments: _order!.id,
                                );
                              },
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (_isLoading) LoadingOverlay(),
              if (_isSuccessPickup)
                PickupOrderOverlay(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
