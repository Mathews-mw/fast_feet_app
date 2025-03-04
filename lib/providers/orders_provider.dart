import 'package:fast_feet_app/services/coordinates_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_feet_app/models/order.dart';
import 'package:fast_feet_app/models/recipient.dart';
import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/services/http_service.dart';

class OrdersProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  List<Order> _items = [];
  List<Order> _userOrders = [];
  List<Order> _nearbyUserOrders = [];

  int get itemsAmount {
    return _items.length;
  }

  List<Order> get items {
    return [..._items];
  }

  List<Order> get nearbyUserOrders {
    return [..._nearbyUserOrders];
  }

  List<Order> get userOrders {
    return [..._userOrders];
  }

  Future<void> loadOrders({
    OrderStatus? status,
    String? search,
  }) async {
    // await Future.delayed(Duration(seconds: 2));
    print('Loading all orders...');

    print('search: $search');

    final queryParameters =
        search != null ? '${status?.value}&search=$search' : '${status?.value}';

    final ordersResponse =
        await _httpService.get("orders?status=$queryParameters");

    print('ordersResponse: $ordersResponse');

    final List<Map<String, dynamic>> ordersList =
        (ordersResponse['orders'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();

    final orders = _mapperHttpToObject(ordersList);

    _items = orders;

    // notifyListeners();
  }

  Future<void> loadNearbyUserOrders({
    OrderStatus? status,
    String? search,
  }) async {
    print('Loading nearby user orders...');

    final coordinatesService = CoordinatesService();

    final currentUserLocation = await coordinatesService.getCurrentPosition();

    final ordersResponse = await _httpService.get(
        "orders/user/nearby?status=${status?.value}&lat=${currentUserLocation.lat}&long=${currentUserLocation.long}&search=$search");

    final List<Map<String, dynamic>> ordersList =
        (ordersResponse['orders'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();

    final orders = _mapperHttpToObject(ordersList);

    _nearbyUserOrders = orders;

    // notifyListeners();
  }

  Future<void> loadUserOrders({OrderStatus? status}) async {
    print('Loading user orders...');

    final ordersResponse =
        await _httpService.get('orders?status=${status?.value}');

    final List<Map<String, dynamic>> ordersList =
        (ordersResponse['orders'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();

    final orders = _mapperHttpToObject(ordersList);

    _userOrders = orders;

    // notifyListeners();
  }

  Future<Order> getOrderById(String orderId) async {
    try {
      final response = await _httpService.get('orders/$orderId/details');

      final order = Order.fromJson(response);

      return order;
    } catch (error) {
      print('Error while try to fetch order: $error');
      rethrow;
    }
  }

  Future<void> pickupOrder(String orderId) async {
    print('pickup order was called!');
    try {
      final response = await _httpService.patch('orders/$orderId/pickup');
      print('response: $response');

      notifyListeners();
    } catch (error) {
      print('Error while try to pickup an order: $error');
      rethrow;
    }
  }

  List<Order> _mapperHttpToObject(List<Map<String, dynamic>> data) {
    final orders = data.map((item) {
      final recipient = Recipient(
        id: item['recipient']['id'],
        name: item['recipient']['name'],
        email: item['recipient']['email'],
        phone: item['recipient']['phone'],
        cpf: item['recipient']['cpf'],
        cep: item['recipient']['cep'],
        street: item['recipient']['street'],
        number: item['recipient']['number'],
        complement: item['recipient']['complement'],
        district: item['recipient']['district'],
        city: item['recipient']['city'],
        state: item['recipient']['state'],
        latitude: item['recipient']['latitude'],
        longitude: item['recipient']['longitude'],
      );

      final order = Order(
        id: item['id'],
        recipientId: item['recipient_id'],
        ownerId: item['owner_id'],
        status: OrderStatus.values.firstWhere(
            (status) => status.value == item['status'],
            orElse: () => OrderStatus.postado),
        statusText: item['status_text'],
        postedAt: DateTime.parse(item['posted_at']),
        withdrawalAt: item['withdrawal_at'] != null
            ? DateTime.parse(item['withdrawal_at'])
            : null,
        deliveryAt: item['delivery_at'] != null
            ? DateTime.parse(item['delivery_at'])
            : null,
        statusUpdatedAt: item['status_updated_at'] != null
            ? DateTime.parse(item['status_updated_at'])
            : null,
        recipient: recipient,
      );

      return order;
    }).toList();

    return orders;
  }
}
