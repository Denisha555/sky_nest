import "package:supabase_flutter/supabase_flutter.dart";

Future<List<Map<String, dynamic>>> getAllBatch() async {
  final response = await Supabase.instance.client
      .from('batch')
      .select();

  if (response.isEmpty) {
    print('No batches found');
    return [];
  } else {
    return List<Map<String, dynamic>>.from(response);
  }
}

Future<List<Map<String, dynamic>>> getBatchDetails(String batchId) async {
  final response = await Supabase.instance.client
      .from('batches_details')
      .select()
      .eq('batch_id', batchId);

  if (response.isEmpty) {
    print('Batch not found');
    return [];
  } else {
    return List<Map<String, dynamic>>.from(response);
  }
}