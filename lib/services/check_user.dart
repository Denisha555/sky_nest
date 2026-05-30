import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'dart:convert';

Future<bool> checkUser(String username, String password) async {
  try {
    var passwordHash = sha256.convert(utf8.encode(password)).toString();
    print(passwordHash);

    final response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('username', username)
        .eq('password', passwordHash);
        
    return response.isNotEmpty;

  } on TimeoutException {
    return false;
  } catch (e, stackTrace) {
    print('ERROR: $e');
    print('STACKTRACE: $stackTrace');
    return false;
  }
}

