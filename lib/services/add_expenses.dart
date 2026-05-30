import "package:supabase_flutter/supabase_flutter.dart";

Future<void> addExpense(String nama, int nominal, String batchId) async {
  try {
    final response = await Supabase.instance.client
        .from('expenses')
        .insert({
      'id': '${batchId}_$nama',
      'name': nama,
      'nominal': nominal,
      'batch_id': batchId,
    });

    if (response.error != null) {
      print('Error adding expense: ${response.error!.message}');
    } else {
      print('Expense added successfully');
    }
  } catch (e) {
    print('Error adding expense: $e');
  }
}