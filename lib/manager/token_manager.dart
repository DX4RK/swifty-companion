import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _expirationKey = 'token_expiration';

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
      Uri.parse('https://your-school-api.com/auth/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'api_key': 'YOUR_API_KEY',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newToken = data['token'];

      DateTime expiration = DateTime.now().add(Duration(days: 7));

      await prefs.setString(_tokenKey, newToken);
      await prefs.setString(_expirationKey, expiration.toIso8601String());

      return newToken;
    } else {
      throw Exception('Failed to generate token');
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expirationKey);
  }
}