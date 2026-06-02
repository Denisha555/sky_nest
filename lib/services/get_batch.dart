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

Future<List<Map<String, dynamic>>> getAllBatchThisMonth() async {
  try {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final response = await Supabase.instance.client
      .from('batches')
      .select()
      .gte('date', firstDayOfMonth)
      .lte('date', lastDayOfMonth);
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

Future<int> getTotalModalThisMonth() async {
  try {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final response = await Supabase.instance.client
      .from('batches_details')
      .select('''
          harga,
          batches!inner(
          *)
''').filter("batches.date", "gte", firstDayOfMonth).filter("batches.date", "lte", lastDayOfMonth);
    if (response.isEmpty) {
      print('No batches found');
      return 0;
    } else {
      int harga = 0;
      for (var data in response) {
        harga += data["harga"] as int;
      }
      return harga;
    }
  } catch (e) {
    print('Error fetching batches: $e');
    return 0;
  }
}

Future<List<Map<String, dynamic>>> getAvailableBatcForProcess() async {
  try {
  final response = await Supabase.instance.client
      .from('batches')
      .select('''
          *,
          batches_details!inner(
          *
          )
      '''
      ).filter("batches_details.metode_cuci", "is", null);

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
  print("Batch Details Response: $response");

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

Future<List<Map<String, dynamic>>> getAvailableBatchForMargin() async {
  try {
    final response = await Supabase.instance.client
      .from('batches')
      .select()
      .filter('harga_jual', 'is', null);

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

Future<int> getHargaJual(String batchId, String field) async {
  try {
    final response = await Supabase.instance.client
      .from('batches')
      .select("harga_jual")
      .eq('id', batchId);

    if (response.isEmpty || response[0][field] == null) {
      print('No batches found');
      return 0;
    } else {
      return response[0][field] as int;
    }
  } catch (e) {
    print('Error fetching batches: $e');
    return 0;
  }
}

Future<int> getProfit(String batchId, String field) async {
  try {
    final response = await Supabase.instance.client
      .from('batches')
      .select("profit")
      .eq('id', batchId);

    if (response.isEmpty || response[0][field] == null) {
      print('No batches found');
      return 0;
    } else {
      return response[0][field] as int;
    }
  } catch (e) {
    print('Error fetching batches: $e');
    return 0;
  }
}

Future<int> getHargaBeli(String batchId) async {
  try {
    final response = await Supabase.instance.client
      .from('batches_details')
      .select('harga')
      .eq('batch_id', batchId);

    if (response.isEmpty) {
      print('No batches found');
      return 0;
    } else {
      int total = response
      .map((item) => int.tryParse(item['harga'].toString()) ?? 0)
      .fold(0, (sum, value) => sum + value);

    return total;
    }
  } catch (e) {
    print('Error fetching batches: $e');
    return 0;
  }
}
