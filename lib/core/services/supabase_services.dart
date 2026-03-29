import 'package:fruit_hub/core/config/app_environment.dart';
import 'package:fruit_hub/core/connectivity/connection_service.dart';
import 'package:fruit_hub/core/connectivity/network_error_matcher.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements DatabaseService {
  SupabaseService({ConnectionService? connectionService})
    : _connectionService = connectionService;

  final SupabaseClient supabase = Supabase.instance.client;
  final ConnectionService? _connectionService;

  static initSupabase() async {
    await Supabase.initialize(
      url: AppEnvironment.requireValue(
        'SUPABASE_URL',
        AppEnvironment.supabaseUrl,
      ),
      anonKey: AppEnvironment.requireValue(
        'SUPABASE_ANON_KEY',
        AppEnvironment.supabaseAnonKey,
      ),
    );
  }

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        await supabase.from(path).upsert(data);
      } else {
        await supabase.from(path).insert(data);
      }
    } catch (error) {
      _reportConnectionIssueIfNeeded(error);
      rethrow;
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  }) async {
    try {
      if (docuementId != null) {
        final data =
            await supabase.from(path).select().eq('id', docuementId).single();
        return data;
      }

      dynamic request = supabase.from(path).select();

      if (query != null && query.isNotEmpty) {
        query.forEach((key, value) {
          if (key == 'orderBy' || key == 'descending' || key == 'limit') {
            return;
          }
          request = request.eq(key, value);
        });

        if (query['orderBy'] != null) {
          final orderByField = query['orderBy'] as String;
          final descending = query['descending'] as bool? ?? false;
          request = request.order(orderByField, ascending: !descending);
        }

        if (query['limit'] != null) {
          final limit = query['limit'] as int;
          request = request.limit(limit);
        }
      }

      final result = await request;

      if (result is List) {
        return result;
      }

      return result;
    } catch (error) {
      _reportConnectionIssueIfNeeded(error);
      rethrow;
    }
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  }) async {
    try {
      final result = await supabase
          .from(path)
          .select()
          .eq('id', docuementId)
          .limit(1);
      return result.isNotEmpty;
    } catch (error) {
      _reportConnectionIssueIfNeeded(error);
      rethrow;
    }
  }

  void _reportConnectionIssueIfNeeded(Object error) {
    if (isLikelyNetworkError(error)) {
      _connectionService?.reportConnectionIssue();
    }
  }
}
