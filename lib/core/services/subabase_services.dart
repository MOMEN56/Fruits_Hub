import 'package:fruit_hub/core/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements DatabaseService {
  final SupabaseClient supabase = Supabase.instance.client;
  static late Supabase _supabase;

  static initSupabase() async {
    _supabase = await Supabase.initialize(
      url: 'https://iwhxwcqfcpcblvdifidv.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3aHh3Y3FmY3BjYmx2ZGlmaWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk2MjA0NzgsImV4cCI6MjA4NTE5NjQ3OH0.BZp9PXcXXOJbb5Npy3wra7JO6Ed0M-JrRqYXSQ8F83c',
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
