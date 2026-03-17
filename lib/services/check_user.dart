import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

Future<bool> checkUser(String username, String password) async {
  var passwordHash = sha256.convert(utf8.encode(password)).toString();
  final response = await Supabase.instance.client
      .from('user')
      .select()
      .eq('username', username)
      .eq('password', passwordHash);

  if (response.isEmpty) {
    print('User not found or incorrect password');
    return false;
  } else {
    return true;
  }
}