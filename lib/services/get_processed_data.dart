import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> getProcessedData() async {
  try {
    final response = await Supabase.instance.client
        .from('batches_details')
        .select('''
          *,
          batches(
            id,
            supplier,
            name,
            date
          )
        ''')
        .not('berat_akhir', 'is', null);

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Error fetching processed data: $e');
    return [];
  }
}

// Future<List<Map<String, dynamic>>> getProcessedData() async {
//   try {
//     final response = await Supabase.instance.client
//         .from('batches_details')
//         .select('''
//           *,
//           batches(
//             id,
//             supplier,
//             name,
//             date
//           )
//         ''')
//         .not('berat_akhir', 'is', null);

//     return List<Map<String, dynamic>>.from(response);
//   } catch (e) {
//     print('Error fetching processed data: $e');
//     return [];
//   }
// }