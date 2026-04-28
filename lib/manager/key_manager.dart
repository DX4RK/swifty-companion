import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _expirationKey = 'token_expiration';

  String get _clientId => dotenv.env['CLIENT_ID'] ?? '';
  String get _clientSecret => dotenv.env['CLIENT_SECRET'] ?? '';

  Future<String> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(_tokenKey);
    String? expirationStr = prefs.getString(_expirationKey);

    if (token != null && expirationStr != null) {
      DateTime expiration = DateTime.parse(expirationStr);

      if (DateTime.now().isBefore(expiration.subtract(Duration(days: 1)))) {
        return token;
      }
    }

    return await _generateNewToken();
  }

  Future<String> _generateNewToken() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse('https://api.intra.42.fr/oauth/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'client_credentials',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newToken = data['access_token'];
      int expiresIn = data['expires_in'];

      DateTime expiration = DateTime.now().add(Duration(seconds: expiresIn));

      await prefs.setString(_tokenKey, newToken);
      await prefs.setString(_expirationKey, expiration.toIso8601String());

      return newToken;
    } else {
      throw Exception('Failed to generate token: ${response.statusCode}');
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expirationKey);
  }
}
