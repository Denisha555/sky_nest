import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<bool> checkUser(String username, String password) async {
  try {
    print('=== 1. START ===');
    var passwordHash = sha256.convert(utf8.encode(password)).toString();
    print('=== 2. HASH DONE ===');

    final response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('username', username)
        .eq('password', passwordHash);

    print('=== 3. RESPONSE: $response ===');
    return response.isNotEmpty;

  } on TimeoutException {
    print('=== ERROR: Timeout ===');
    return false;
  } catch (e, stackTrace) {
    print('=== ERROR: $e ===');
    print('=== STACKTRACE: $stackTrace ===');
    return false;
  }
}