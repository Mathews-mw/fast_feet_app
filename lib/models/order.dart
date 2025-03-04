import 'package:fast_feet_app/@types/order_status.dart';
import 'package:fast_feet_app/models/recipient.dart';

class Order {
  final String id;
  final String recipientId;
  final String? ownerId;
  final OrderStatus status;
  final String statusText;
  final DateTime postedAt;
  final DateTime? withdrawalAt;
  final DateTime? deliveryAt;
  final DateTime? statusUpdatedAt;
  final Recipient recipient;

  Order({
    required this.id,
    required this.recipientId,
    required this.ownerId,
    required this.status,
    required this.statusText,
    required this.postedAt,
    this.withdrawalAt,
    this.deliveryAt,
    this.statusUpdatedAt,
    required this.recipient,
  });

  set recipientId(String recipientId) {
    this.recipientId = recipientId;
  }

  set ownerId(String? ownerId) {
    this.ownerId = ownerId;
  }

  set status(OrderStatus status) {
    this.status = status;
  }

  set postedAt(DateTime postedAt) {
    this.postedAt = postedAt;
  }

  set withdrawalAt(DateTime? withdrawalAt) {
    this.withdrawalAt = withdrawalAt;
  }

  set deliveryAt(DateTime? deliveryAt) {
    this.deliveryAt = deliveryAt;
  }

  set statusUpdatedAt(DateTime? statusUpdatedAt) {
    this.statusUpdatedAt = statusUpdatedAt;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      recipientId: json['recipient_id'],
      ownerId: json['owner_id'],
      status: OrderStatus.values.firstWhere(
          (status) => status.value == json['status'],
          orElse: () => OrderStatus.postado),
      statusText: json['status_text'],
      postedAt: DateTime.parse(json['posted_at']),
      withdrawalAt: json['withdrawal_at'] != null
          ? DateTime.parse(json['withdrawal_at'])
          : null,
      deliveryAt: json['delivery_at'] != null
          ? DateTime.parse(json['delivery_at'])
          : null,
      statusUpdatedAt: json['status_updated_at'] != null
          ? DateTime.parse(json['status_updated_at'])
          : null,
      recipient: Recipient.fromJson(json['recipient']),
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, recipientId: $recipientId, ownerId: $ownerId, status: $status, postedAt: $postedAt, withdrawalAt: $withdrawalAt, deliveryAt: $deliveryAt, statusUpdatedAt: $statusUpdatedAt)';
  }
}
