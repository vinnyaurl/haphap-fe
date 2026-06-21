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
  // Multipart File Upload
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> uploadFile(
    String path,
    String filePath,
    String fieldName,
  ) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final request = http.MultipartRequest('POST', uri);
      
      // Add auth header
      final token = await TokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // Add file
      request.files.add(await http.MultipartFile.fromPath(
        fieldName, 
        filePath,
        contentType: _getMediaType(filePath),
      ));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message:
            'Tidak dapat mengunggah file. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Multipart POST (multiple files + text fields)
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, String> fields,
    Map<String, String> files = const {},
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

      // File fields
      for (final entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key, 
            entry.value,
            contentType: _getMediaType(entry.value),
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
        message:
            'Tidak dapat mengirim data. Periksa koneksi internet kamu.',
        statusCode: 0,
      );
    }
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

  static MediaType _getMediaType(String filePath) {
    final ext = filePath.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'jpeg') {
      return MediaType('image', 'jpeg');
    } else if (ext == 'png') {
      return MediaType('image', 'png');
    } else if (ext == 'pdf') {
      return MediaType('application', 'pdf');
    } else if (ext == 'doc') {
      return MediaType('application', 'msword');
    } else if (ext == 'docx') {
      return MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
    }
    return MediaType('application', 'octet-stream');
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}