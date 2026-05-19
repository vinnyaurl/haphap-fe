import 'dart:convert';
import 'package:http/http.dart' as http;

/// Central HTTP client for HapHap API.
/// Base URL targets localhost:3000 works for Chrome web debug.
/// For Android emulator, change to: http://10.0.2.2:3000/api
/// For physical device, change to your machine's local IP.
class ApiClient {
  static const String baseUrl = 'http://localhost:3000/api';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Throws [ApiException] on non-2xx responses.
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;


      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        final message = decoded['message'] ?? 'Terjadi kesalahan pada server.';
        throw ApiException(message: message.toString(), statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      // Network error (no connection, CORS, etc.)
      throw ApiException(
        message: 'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }
}

/// Thrown when the API returns a non-2xx response or a network error occurs.
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}