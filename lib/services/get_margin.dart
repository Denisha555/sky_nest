import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> getMarginData() async {
  try {
    final response = await Supabase.instance.client
        .from('batches')
        .select()
        .gt('harga_jual', 0)
        .order('date', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Error get margin data: $e');
    return [];
  }
}


// import 'package:supabase_flutter/supabase_flutter.dart';

// Future<List<Map<String, dynamic>>> getMarginData() async {
//   try {
//     final response = await Supabase.instance.client
//         .from('batches')
//         .select()
//         .order('date', ascending: false);

//     return List<Map<String, dynamic>>.from(response);
//   } catch (e) {
//     print('Error get margin data: $e');
//     return [];
//   }
// }