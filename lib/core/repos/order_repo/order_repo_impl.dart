import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/services/firestore_service.dart';
import 'package:fruit_hub/core/services/subabase_services.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/checkout/data/models/order_model.dart';
import 'package:fruit_hub/features/checkout/domain/entites/order_entity.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';

class OrderRepoImpl implements OrderRepo {
  final DatabaseService fireStoreService;

  OrderRepoImpl(this.fireStoreService);
  @override
  Future<Either<Failure, String>> addOrder({
    required OrderInputEntity order,
  }) async {
    try {
      var orderModel = OrderModel.fromEntity(order);
      await fireStoreService.addData(
        path: BackendEndpoint.addOrder,
        data: orderModel.toJson(),
      );
      try {
        await fireStoreService.addData(
          path: BackendEndpoint.notifications,
          data: {
            'type': 'order_status',
            'title_ar':
                '\u062A\u062D\u062F\u064A\u062B \u0627\u0644\u0637\u0644\u0628',
            'message_ar':
                '\u064A\u062A\u0645 \u0627\u0644\u0645\u0631\u0627\u062C\u0639\u0629',
            'status': 'pending',
            'user_id': orderModel.uId,
            'order_id': orderModel.orderId,
            'is_read': false,
            'created_at': DateTime.now().toUtc().toIso8601String(),
          },
        );
        await fireStoreService.addData(
          path: BackendEndpoint.notifications,
          data: {
            'type': 'new_order',
            'title_ar': 'طلب جديد',
            'message_ar': 'قام عميل بإنشاء طلب جديد',
            'status': 'pending',
            'user_id': BackendEndpoint.adminNotificationsUserId,
            'order_id': orderModel.orderId,
            'is_read': false,
            'created_at': DateTime.now().toUtc().toIso8601String(),
          },
        );
      } catch (_) {
        // Order creation should not fail if notification insert fails.
      }
      await _tryNotifyUserAboutOrderCreated(
        userId: orderModel.uId,
        orderId: orderModel.orderId,
      );
      await _tryNotifyDashboardAboutNewOrder(orderId: orderModel.orderId);
      return Right(orderModel.orderId);
    } catch (e) {
      return Left((ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<UserOrderEntity>>> getUserOrders({
    required String userId,
  }) async {
    try {
      final rawData = await fireStoreService.getData(
        path: BackendEndpoint.addOrder,
        query: {'u_id': userId, 'orderBy': 'created_at', 'descending': true},
      );
      final rawOrders =
          (rawData as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();

      await _syncDeliveredOrdersSellingCount(rawOrders);

      final orders = rawOrders.map(UserOrderEntity.fromJson).toList();

      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _syncDeliveredOrdersSellingCount(
    List<Map<String, dynamic>> rawOrders,
  ) async {
    for (final rawOrder in rawOrders) {
      final normalizedStatus =
          (rawOrder['status'] ?? '').toString().trim().toLowerCase();
      final hasAppliedFlag = rawOrder.containsKey('selling_count_applied');
      final isDelivered =
          normalizedStatus == 'delivered' ||
          (hasAppliedFlag && normalizedStatus == 'completed');
      final isAlreadyApplied =
          hasAppliedFlag
              ? rawOrder['selling_count_applied'] == true
              : normalizedStatus == 'completed';
      if (!isDelivered || isAlreadyApplied) {
        continue;
      }

      final orderProducts = _extractOrderProductsQuantities(
        rawOrder['order_products'],
      );
      if (orderProducts.isEmpty) {
        await _markOrderSellingCountApplied(rawOrder);
        rawOrder['selling_count_applied'] = true;
        rawOrder['status'] = 'completed';
        continue;
      }

      try {
        for (final entry in orderProducts.entries) {
          await _increaseProductSellingCount(
            productCode: entry.key,
            incrementBy: entry.value,
          );
        }
        await _markOrderSellingCountApplied(rawOrder);
        rawOrder['selling_count_applied'] = true;
        rawOrder['status'] = 'completed';
      } catch (e, stackTrace) {
        log(
          'Failed to sync selling count for order ${rawOrder['order_id']}: $e',
          stackTrace: stackTrace,
        );
      }
    }
  }

  Map<String, int> _extractOrderProductsQuantities(dynamic rawProducts) {
    final quantitiesByCode = <String, int>{};
    if (rawProducts is! List) {
      return quantitiesByCode;
    }

    for (final rawProduct in rawProducts.whereType<Map>()) {
      final product = Map<String, dynamic>.from(rawProduct);
      final productCode = (product['code'] ?? '').toString();
      final quantity =
          (product['quantity'] as num?)?.toInt() ??
          int.tryParse(product['quantity']?.toString() ?? '') ??
          0;

      if (productCode.isEmpty || quantity <= 0) {
        continue;
      }

      quantitiesByCode.update(
        productCode,
        (oldValue) => oldValue + quantity,
        ifAbsent: () => quantity,
      );
    }

    return quantitiesByCode;
  }

  Future<void> _increaseProductSellingCount({
    required String productCode,
    required int incrementBy,
  }) async {
    if (incrementBy <= 0) {
      return;
    }

    if (fireStoreService is SupabaseService) {
      await _increaseProductSellingCountInSupabase(
        productCode: productCode,
        incrementBy: incrementBy,
      );
      return;
    }

    if (fireStoreService is FireStoreService) {
      await _increaseProductSellingCountInFirestore(
        productCode: productCode,
        incrementBy: incrementBy,
      );
      return;
    }

    throw UnsupportedError(
      'Database service is not supported: ${fireStoreService.runtimeType}',
    );
  }

  Future<void> _increaseProductSellingCountInSupabase({
    required String productCode,
    required int incrementBy,
  }) async {
    final supabase = (fireStoreService as SupabaseService).supabase;
    final productRows = await supabase
        .from(BackendEndpoint.getProducts)
        .select('selling_count')
        .eq('code', productCode)
        .limit(1);

    if (productRows.isEmpty) {
      return;
    }

    final productData = productRows.first;
    final currentSellingCount =
        (productData['selling_count'] as num?)?.toInt() ?? 0;

    await supabase
        .from(BackendEndpoint.getProducts)
        .update({'selling_count': currentSellingCount + incrementBy})
        .eq('code', productCode);
  }

  Future<void> _increaseProductSellingCountInFirestore({
    required String productCode,
    required int incrementBy,
  }) async {
    final firestore = (fireStoreService as FireStoreService).firestore;
    final snapshot =
        await firestore
            .collection(BackendEndpoint.getProducts)
            .where('code', isEqualTo: productCode)
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final productDoc = snapshot.docs.first;
    final currentSellingCount =
        (productDoc.data()['selling_count'] as num?)?.toInt() ?? 0;
    await productDoc.reference.update({
      'selling_count': currentSellingCount + incrementBy,
    });
  }

  Future<void> _markOrderSellingCountApplied(
    Map<String, dynamic> rawOrder,
  ) async {
    final orderId = (rawOrder['order_id'] ?? '').toString();
    if (orderId.isEmpty) {
      return;
    }

    if (fireStoreService is SupabaseService) {
      final supabase = (fireStoreService as SupabaseService).supabase;
      try {
        await supabase
            .from(BackendEndpoint.addOrder)
            .update({'selling_count_applied': true})
            .eq('order_id', orderId);
      } catch (e) {
        if (!_isMissingColumnError(e, 'selling_count_applied')) {
          rethrow;
        }
        await supabase
            .from(BackendEndpoint.addOrder)
            .update({'status': 'completed'})
            .eq('order_id', orderId);
      }
      return;
    }

    if (fireStoreService is FireStoreService) {
      final firestore = (fireStoreService as FireStoreService).firestore;
      final snapshot =
          await firestore
              .collection(BackendEndpoint.addOrder)
              .where('order_id', isEqualTo: orderId)
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      await snapshot.docs.first.reference.update({
        'selling_count_applied': true,
      });
    }
  }

  bool _isMissingColumnError(Object error, String columnName) {
    final errorText = error.toString().toLowerCase();
    return errorText.contains('pgrst204') &&
        errorText.contains('could not find') &&
        errorText.contains(columnName.toLowerCase());
  }

  Future<void> _tryNotifyUserAboutOrderCreated({
    required String userId,
    required String orderId,
  }) async {
    if (fireStoreService is! SupabaseService) {
      return;
    }
    final supabase = (fireStoreService as SupabaseService).supabase;
    try {
      final response = await supabase.functions.invoke(
        BackendEndpoint.sendPushNotificationFunction,
        body: {
          'type': 'order_status',
          'target': 'user',
          'user_id': userId,
          'order_id': orderId,
          'status': 'pending',
          'title_ar':
              '\u062A\u062D\u062F\u064A\u062B \u0627\u0644\u0637\u0644\u0628',
          'message_ar':
              '\u064A\u062A\u0645 \u0627\u0644\u0645\u0631\u0627\u062C\u0639\u0629',
        },
      );
      log('[Push] User order-created response: ${response.data}');
    } catch (e, stackTrace) {
      log(
        '[Push] User order-created notification failed: $e',
        stackTrace: stackTrace,
      );
      // Push send is best-effort to avoid blocking checkout.
    }
  }

  Future<void> _tryNotifyDashboardAboutNewOrder({
    required String orderId,
  }) async {
    if (fireStoreService is! SupabaseService) {
      return;
    }
    final supabase = (fireStoreService as SupabaseService).supabase;
    try {
      final response = await supabase.functions.invoke(
        BackendEndpoint.sendPushNotificationFunction,
        body: {
          'type': 'new_order',
          'target': 'user',
          'user_id': BackendEndpoint.adminNotificationsUserId,
          'order_id': orderId,
          'status': 'pending',
          'title_ar': 'طلب جديد',
          'message_ar': 'قام عميل بإنشاء طلب جديد',
        },
      );
      log('[Push] Dashboard new-order response: ${response.data}');
    } catch (e, stackTrace) {
      log(
        '[Push] Dashboard new-order notification failed: $e',
        stackTrace: stackTrace,
      );
      // Push send is best-effort to avoid blocking checkout.
    }
  }
}
