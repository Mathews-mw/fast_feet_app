import 'package:flutter/material.dart';
import 'package:fast_feet_app/models/recipient.dart';
import 'package:fast_feet_app/services/http_service.dart';

class RecipientsProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  bool _isLoading = false;
  List<Recipient> _recipients = [];

  bool get isLoading => _isLoading;

  List<Recipient> get recipients {
    return [..._recipients];
  }

  Future<void> loadRecipients({String? search}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final queryParameters = search != null ? 'search=$search' : '';

      final response = await _httpService.get("recipients?$queryParameters");

      final recipients =
          (response as List).map((item) => Recipient.fromJson(item)).toList();

      _recipients = recipients;
    } catch (err) {
      print('Erro while try to fetch recipients');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerNewRecipient(Map<String, dynamic> data) async {
    print('data: $data');
    try {
      final response = await _httpService.post('recipients', data);
      print('Create recipient response: $response');

      notifyListeners();
    } catch (e) {
      print('Create recipient error: $e');
      rethrow;
    }
  }
}
