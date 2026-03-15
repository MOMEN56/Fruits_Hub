import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub/core/services/data_service.dart';

class FireStoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      await firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  }) async {
    if (docuementId != null) {
      final data = await firestore.collection(path).doc(docuementId).get();
      return data.data();
    }

    Query<Map<String, dynamic>> data = firestore.collection(path);
    if (query != null) {
      query.forEach((key, value) {
        if (key == 'orderBy' || key == 'descending' || key == 'limit') return;
        data = data.where(key, isEqualTo: value);
      });

      if (query['orderBy'] != null) {
        final orderByField = query['orderBy'];
        final descending = query['descending'] as bool? ?? false;
        data = data.orderBy(orderByField, descending: descending);
      }

      if (query['limit'] != null) {
        final limit = query['limit'];
        data = data.limit(limit);
      }
    }

    final result = await data.get();
    return result.docs.map((e) => e.data()).toList();
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  }) async {
    final data = await firestore.collection(path).doc(docuementId).get();
    return data.exists;
  }

  /// Streams data from Firestore and applies optional query filters.
  Stream<List<Map<String, dynamic>>> streamData({
    required String path,
    Map<String, dynamic>? query,
  }) async* {
    Query<Map<String, dynamic>> data = firestore.collection(path);
    if (query != null) {
      query.forEach((key, value) {
        if (key == 'orderBy' || key == 'descending' || key == 'limit') return;
        data = data.where(key, isEqualTo: value);
      });

      if (query['orderBy'] != null) {
        final orderByField = query['orderBy'];
        final descending = query['descending'] as bool? ?? false;
        data = data.orderBy(orderByField, descending: descending);
      }

      if (query['limit'] != null) {
        final limit = query['limit'];
        data = data.limit(limit);
      }
    }

    await for (final result in data.snapshots()) {
      yield result.docs.map((e) => e.data()).toList();
    }
  }
}
