import 'package:flutter_application_1/services/check_batch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> addBatchWithDetails({
  required String batchName,
  required String date,
  required String supplier,
  required List<Map<String, dynamic>> details,
}) async {
  String batchId = '';
  
  try {
    // Generate batch ID (sama seperti sebelumnya)
    final data = await checkBatch("${date}_$batchName");
    if (data.isNotEmpty) {
      batchId = "${date}_${batchName}_${(data.length + 1).toString().padLeft(2, '0')}";
    } else {
      batchId = "${date}_${batchName}_01";
    }

    // Insert batch dulu
    await Supabase.instance.client.from('batches').insert({
      'id': batchId,
      'name': batchName,
      'date': date,
      'supplier': supplier,
    });

    // Insert semua details, kalau salah satu gagal langsung throw
    for (final detail in details) {
      await Supabase.instance.client.from('batches_details').insert({
        'id': '${batchId}_${detail['komposisi']}',
        'batch_id': batchId,
        'komposisi': detail['komposisi'],
        'berat': detail['berat'],
      });
    }

    return batchId; // sukses semua

  } catch (error) {
    print('Error: $error');

    // Kalau batchId sudah terbuat, hapus batchnya (rollback manual)
    if (batchId.isNotEmpty) {
      try {
        await Supabase.instance.client
            .from('batches')
            .delete()
            .eq('id', batchId);
        print('Batch $batchId berhasil dihapus karena error');
      } catch (deleteError) {
        print('Gagal hapus batch: $deleteError');
      }
    }

    return null; // gagal
  }
}