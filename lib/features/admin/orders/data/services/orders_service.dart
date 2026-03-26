import 'dart:developer';

import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/admin/orders/domain/entities/dashboard_order_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersService {
  OrdersService({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabaseClient;

  Future<List<UserOrdersGroupEntity>> fetchGroupedOrders() async {
    final ordersResponse = await _supabaseClient
        .from(BackendEndpoint.addOrder)
        .select()
        .order('created_at', ascending: false);
    final usersResponse = await _supabaseClient
        .from(BackendEndpoint.getUsersData)
        .select('u_id, name, email');

    final rawOrders = _toMapList(ordersResponse);
    final rawUsers = _toMapList(usersResponse);

    final usersById = <String, _UserProfile>{};
    for (final rawUser in rawUsers) {
      final userId = (rawUser['u_id'] ?? '').toString().trim();
      if (userId.isEmpty) {
        continue;
      }
      usersById[userId] = _UserProfile(
        id: userId,
        name: (rawUser['name'] ?? '').toString().trim(),
        email: (rawUser['email'] ?? '').toString().trim(),
      );
    }

    final groupedOrders = <String, List<DashboardOrderEntity>>{};
    for (final rawOrder in rawOrders) {
      try {
        final parsedOrder = DashboardOrderEntity.fromJson(rawOrder);
        if (parsedOrder == null) {
          continue;
        }
        groupedOrders
            .putIfAbsent(parsedOrder.userId, () => <DashboardOrderEntity>[])
            .add(parsedOrder);
      } catch (error, stackTrace) {
        log(
          'Skipping malformed order row: $error | row: $rawOrder',
          stackTrace: stackTrace,
        );
      }
    }

    final groups = <UserOrdersGroupEntity>[];
    for (final entry in groupedOrders.entries) {
      final userProfile =
          usersById[entry.key] ?? _UserProfile(id: entry.key, name: '', email: '');

      groups.add(
        UserOrdersGroupEntity(
          userId: userProfile.id,
          userName: userProfile.name,
          userEmail: userProfile.email,
          orders: entry.value,
        ),
      );
    }

    groups.sort((a, b) {
      final aDate = a.latestCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.latestCreatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return groups;
  }

  Future<void> updateOrderStatus({
    required DashboardOrderEntity order,
    required String nextStatus,
  }) async {
    final query = _supabaseClient
        .from(BackendEndpoint.addOrder)
        .update(<String, dynamic>{'status': nextStatus});

    if (order.identifierField == 'order_id') {
      await query.eq('order_id', order.identifierValue);
      return;
    }

    await query.eq('id', order.identifierValue);
  }

  List<Map<String, dynamic>> _toMapList(dynamic rawData) {
    if (rawData is! List) {
      return const <Map<String, dynamic>>[];
    }
    return rawData
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }
}

class _UserProfile {
  const _UserProfile({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;
}
