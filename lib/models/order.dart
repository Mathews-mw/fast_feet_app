import 'package:fast_feet_app/models/recipient.dart';

class Order {
  final String id;
  final String recipientId;
  final String? ownerId;
  final String status;
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

  set status(String status) {
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

  @override
  String toString() {
    return 'Order(id: $id, recipientId: $recipientId, ownerId: $ownerId, status: $status, postedAt: $postedAt, withdrawalAt: $withdrawalAt, deliveryAt: $deliveryAt, statusUpdatedAt: $statusUpdatedAt)';
  }
}
