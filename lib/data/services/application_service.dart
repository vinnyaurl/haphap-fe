import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/application_model.dart';

class ApplicationService {
  ApplicationService._();

  static Future<List<ApplicationModel>> fetchAll() async {
    final json = await ApiClient.get('/applications');
    final data = json['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<ApplicationModel>> findMyApplications() async {
    final json = await ApiClient.get('/applications/me');
    final data = json['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => ApplicationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> updateStatus(
    String applicationId, {
    required String status,
    String? rejectNote,
  }) async {
    final body = <String, dynamic>{
      'status': status,
      if (rejectNote != null && rejectNote.isNotEmpty) 'rejectNote': rejectNote,
    };
    await ApiClient.patch('/applications/$applicationId', body);
  }

  // POST /api/applications (multipart)
  static Future<Map<String, dynamic>> createApplication({
    required Map<String, String> fields,
    required Map<String, String> files,
  }) async {
    return await ApiClient.postMultipart(
      '/applications',
      fields: fields,
      files: files,
    );
  }
}
