import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';

class CartRemoteDataSource {
  CartRemoteDataSource(this._databaseService);

  final DatabaseService _databaseService;

  Future<String?> fetchRaw(String userId) async {
    try {
      final data = await _databaseService.getData(
        path: BackendEndpoint.userCarts,
        docuementId: userId,
      );
      if (data is Map) {
        final raw = data['cart_json'];
        return raw is String ? raw : raw?.toString();
      }
    } catch (_) {}
    return null;
  }

  Future<void> saveRaw(String userId, String raw) async {
    try {
      await _databaseService.addData(
        path: BackendEndpoint.userCarts,
        documentId: userId,
        data: {
          'id': userId,
          'cart_json': raw,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (_) {}
  }
}
