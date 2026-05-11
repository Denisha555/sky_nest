import 'package:flutter_application_1/services/check_batch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> editBatchWithDetails({
  required String batchId,
  required String metodeCuci,
  required String komposisi,
  required String beratAkhir,
}) async {
  try {
    print("Editing batch with ID: $batchId, Komposisi: $komposisi");
    print("New beratAkhir: $beratAkhir");
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
