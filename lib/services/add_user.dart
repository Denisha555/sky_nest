import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<void> addUser(String password, String username) async {
  var passwordHash = sha256.convert(utf8.encode(password)).toString();
  final response = await Supabase.instance.client
      .from('user')
      .insert({'username': username, 'password': passwordHash});
    
  if (response.error != null) {
    print('Error adding user: ${response.error!.message}');
  } else {
    print('User added successfully!');
  }
}
