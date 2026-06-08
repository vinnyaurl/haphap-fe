import 'package:haphap_fe/core/network/api_client.dart';
import 'package:haphap_fe/data/models/merchant_model.dart';

class MenuService {
  MenuService._();

  /// Fetch semua menu milik merchant yang sedang login.
  /// Endpoint: GET /menus
  static Future<List<MenuItemModel>> getAllMenus() async {
    final json = await ApiClient.get('/menus');
    final list = json['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Update menu item.
  /// Endpoint: PATCH /menus/:menuItemId
  static Future<MenuItemModel> updateMenu(String menuItemId, Map<String, dynamic> data) async {
    final json = await ApiClient.patch('/menus/$menuItemId', data);
    return MenuItemModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  /// Hapus menu item (soft-delete di backend: isActive = false).
  /// Endpoint: DELETE /menus/:menuItemId
  static Future<void> deleteMenu(String menuItemId) async {
    await ApiClient.delete('/menus/$menuItemId');
  }

  /// Upload gambar untuk menu item.
  /// Endpoint: POST /menus/:menuItemId/image (multipart file upload)
  static Future<Map<String, dynamic>> uploadImage(String menuItemId, String filePath) async {
    final json = await ApiClient.uploadFile('/menus/$menuItemId/image', filePath, 'file');
    return json['data'] as Map<String, dynamic>? ?? {};
  }
}
