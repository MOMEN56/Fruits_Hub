abstract class DatabaseServices {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });
  Future<dynamic> getUserData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  });
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  });
}
