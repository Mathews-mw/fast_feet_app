import 'package:flutter/material.dart';
import 'package:fast_feet_app/models/order.dart';
import 'package:fast_feet_app/models/recipient.dart';
import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/services/http_service.dart';

class OrdersProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  List<Order> _items = [];
  List<Order> _userOrders = [];

  int get itemsAmount {
    return _items.length;
  }

  List<Order> get items {
    return [..._items];
  }

  List<Order> get userOrders {
    return [..._userOrders];
  }

  Future<void> loadOrders({OrderStatus? status}) async {
    // await Future.delayed(Duration(seconds: 2));
    print('Loading all orders...');

    final ordersResponse =
        await _httpService.get("orders?status=${status?.value}");

    final List<Map<String, dynamic>> ordersList =
        (ordersResponse['orders'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();

    final orders = _mapperHttpToObject(ordersList);
    _items = orders;
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
        status: item['status'],
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
