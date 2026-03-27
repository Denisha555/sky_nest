import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> checkBatch(String batchId) async {
  final response = await Supabase.instance.client
      .from ('batches')
      .select()
      .like("id", '%$batchId%');

  if (response.isEmpty) {
    print('Batch not found');
    return [];
  } else {
    return List<Map<String, dynamic>>.from(response);
  }
}