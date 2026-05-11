import "package:supabase_flutter/supabase_flutter.dart";

Future<List<Map<String, dynamic>>> getAllBatch() async {
  try {
  final response = await Supabase.instance.client
      .from('batches')
      .select();

  if (response.isEmpty) {
    print('No batches found');
    return [];
  } else {
    return List<Map<String, dynamic>>.from(response);
  }
  } catch (e) {
    print('Error fetching batches: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> getBatchDetails(String batchId) async {
  try {
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
  } catch (e) {
    print('Error fetching batch details: $e');
    return [];
  }
}