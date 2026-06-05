import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> deleteMargin(String batchId) async {
  try {
    await Supabase.instance.client
        .from('batches')
        .update({
          'harga_jual': 0,
          'profit': 0,
        })
        .eq('id', batchId);

    return true;
  } catch (e) {
    print('Delete Margin Error: $e');
    return false;
  }
}