import 'package:fruit_hub/core/config/app_environment.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements DatabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

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
    if (documentId != null) {
      await supabase.from(path).upsert(data);
    } else {
      await supabase.from(path).insert(data);
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? docuementId,
    Map<String, dynamic>? query,
  }) async {
    if (docuementId != null) {
      final data =
          await supabase.from(path).select().eq('id', docuementId).single();
      return data; // Map
    }

    dynamic request = supabase.from(path).select();

    if (query != null && query.isNotEmpty) {
      query.forEach((key, value) {
        if (key == 'orderBy' || key == 'descending' || key == 'limit') return;
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

    // لو جايب أكتر من عنصر، رجع List
    if (result is List) {
      return result;
    }

    // لو Map (مثلاً select.single)، رجعه Map
    return result;
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String docuementId,
  }) async {
    final result = await supabase
        .from(path)
        .select()
        .eq('id', docuementId)
        .limit(1);
    return result.isNotEmpty;
  }
}
