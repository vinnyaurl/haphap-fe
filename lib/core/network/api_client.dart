import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:haphap_fe/core/network/token_manager.dart';

class ApiClient {
  ApiClient._();

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:3000/api';

  static Future<Map<String, String>> get _headers async {
    final token = await TokenManager.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ---------------------------------------------------------------------------
  // GET
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.get(uri, headers: await _headers);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // POST
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.post(
        uri,
        headers: await _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PATCH
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.patch(
        uri,
        headers: await _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final response = await http.delete(uri, headers: await _headers);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message:
            'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Multipart POST — text fields + optional file
  // Digunakan untuk endpoint yang menerima multipart/form-data,
  // misalnya POST /menus (name, originalPrice, description?, image?).
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> multipartPost(
    String path, {
    required Map<String, String> fields,
    String? filePath,
    String fileFieldName = 'image',
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final request = http.MultipartRequest('POST', uri);

      // Auth header
      final token = await TokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Text fields
      request.fields.addAll(fields);

      // Optional file — eksplisit set contentType agar Supabase tidak
      // menolak dengan error "mime type application/octet-stream not supported".
      if (filePath != null && filePath.isNotEmpty) {
        final mimeType = _mimeTypeFromPath(filePath);
        request.files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            filePath,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Tidak dapat mengirim data. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }

  static String _mimeTypeFromPath(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    const map = <String, String>{
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
      'gif': 'image/gif',
      'heic': 'image/heic',
      'heif': 'image/heif',
    };
    return map[ext] ?? 'image/jpeg';
  }

  // ---------------------------------------------------------------------------
  // Shared response handler
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _handleResponse(http.Response response) {
    debugPrint('RAW RESPONSE: ${response.body}');
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final message =
        decoded['message'] ?? 'Terjadi kesalahan pada server.';
    throw ApiException(
      message: message.toString(),
      statusCode: response.statusCode,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}