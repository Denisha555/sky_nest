import 'package:flutter_application_1/services/check_batch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> editBatchWithDetails({
  required String batchId,
  required String metodeCuci,
  required String komposisi,
  required String beratAkhir,
}) async {
  try {
    await Supabase.instance.client
        .from('batches_details')
        .update({'berat_akhir': beratAkhir, 'metode_cuci': metodeCuci})
        .eq('id', batchId);
    return true; // sukses semua
  } catch (error) {
    print('Error: $error');
    return false; // gagal
  }
}

Future<bool> editBatch({
  required String field,
  required dynamic value,
  required String batchId,
}) async {
  try {
    await Supabase.instance.client
        .from('batches')
        .update({field: value})
        .eq('id', batchId);
    return true; // sukses semua
  } catch (error) {
    print('Error: $error');
    return false; // gagal
  }
}


