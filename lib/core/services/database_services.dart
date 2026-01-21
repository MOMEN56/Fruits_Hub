import 'package:fruit_hub/features/auth/domain/entites/user_entity.dart';

abstract class DatabaseServices {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });
  Future<Map<String, dynamic>> getUserData({
    required String path,
    required String docuementId,
  });
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  });
}
