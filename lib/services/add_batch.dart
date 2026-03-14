import 'package:flutter_application_1/services/check_batch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> addBatch(String batchName, String date) async {
  String batchId = "${date}_$batchName";
  final data = await checkBatch(batchId);
  if (data.isNotEmpty) {
    batchId = "${date}_${batchName}_${(data.length + 1).toString().padLeft(2, '0')}";
  } else {
    batchId = "${date}_${batchName}_01";
  }

  final response = await Supabase.instance.client
      .from('batches')
      .insert({'id': batchId,'name': batchName, 'date': date});

  if (response.error != null) {
    print('Error adding batch: ${response.error!.message}');
  } else {
    print('Batch added successfully!');
  }
}

Future<void> addBatchDetails(String batchId, String komposisi, int berat) async {
  final response = await Supabase.instance.client
      .from('batch_details')
      .insert({'batch_id': batchId, 'komposisi': komposisi, 'berat': berat});

  if (response.error != null) {
    print('Error adding batch details: ${response.error!.message}');
  } else {
    print('Batch details added successfully!');
  }
}