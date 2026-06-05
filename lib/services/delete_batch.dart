import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> deleteBatchDetail(String batchId) async {
  try {
    await Supabase.instance.client
        .from('batches_details')
        .delete()
        .eq('id', batchId);

    return true;
  } catch (error) {
    print('Error delete: $error');
    return false;
  }
}