import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> getUserId(String username) async {
  try {
    final response = await Supabase.instance.client
      .from('user')
      .select('id')
      .eq('username', username);

    if (response.isEmpty) {
      print('User not found');
      return "";
    }

    return response[0]["id"] as String;
  } catch (e) {
    print('Error getting user ID: $e');
    return "";
  }
}

Future<String> getUsername(String userId) async {
  try {
    final response = await Supabase.instance.client
      .from('user')
      .select('username')
      .eq('id', userId);

    if (response.isEmpty) {
      print('User not found');
      return "";
    }

    return response[0]["username"] as String;
  } catch (e) {
    print('Error getting user ID: $e');
    return "";
  }
}


