import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:fast_feet_app/@exceptions/api_exceptions.dart';
import 'package:fast_feet_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpService {
  final String _baseUrl =
      'https://careful-previously-opossum.ngrok-free.app/api';

  Future<dynamic> get(String endpoint) async {
    final token = await AuthService().getToken();

    print('stored token: $token');

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {"Authorization": 'Bearer $token'},
      );
      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final token = await AuthService().getToken();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final token = await AuthService().getToken();

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, [Map<String, dynamic>? data]) async {
    final token = await AuthService().getToken();

    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token'
        },
        body: data != null ? jsonEncode(data) : null,
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint, Map<String, dynamic> data) async {
    final token = await AuthService().getToken();

    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {"Authorization": 'Bearer $token'},
      );

      return _handleResponse(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<int> multiPartRequest(String endpoint, File file) async {
    final token = await AuthService().getToken();

    try {
      final request = http.MultipartRequest(
        'PATCH',
        Uri.parse("$_baseUrl/$endpoint"),
      );

      final mimeType = lookupMimeType(file.path);

      final [type, subtype] = mimeType!.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType(type, subtype),
      ));

      request.headers.addAll({"Authorization": 'Bearer $token'});

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Upload realizado com sucesso!');
      } else {
        print('Erro no upload: ${response.statusCode}');
      }

      return response.statusCode;
    } catch (error) {
      print('multipart error: $error');
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode == 401) {
      if (data['code'] == 'AUTH_EXPIRED_TOKEN') {
        refreshToken().then((value) {}).catchError((error) {
          throw ApiExceptions(code: data['code'], message: data['message']);
        });

        throw ApiExceptions(code: data['code'], message: data['message']);
      }
      throw ApiExceptions(code: data['code'], message: data['message']);
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ApiExceptions(code: data['code'], message: data['message']);
    }
  }

  Future<void> refreshToken() async {
    final token = await AuthService().getToken();

    final response = await http.patch(
      Uri.parse("$_baseUrl/auth/refresh-token"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await AuthService().saveToken(data['token']);
    } else {
      await AuthService().removeToken();
      throw Exception("Sessão expirada. Faça login novamente.");
    }
  }
}
