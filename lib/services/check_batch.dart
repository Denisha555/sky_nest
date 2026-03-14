import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> checkBatch(String batchId) async {
  final response = await Supabase.instance.client
      .from ('batches')
      .select()
      .eq("id", batchId);

  return response;
}