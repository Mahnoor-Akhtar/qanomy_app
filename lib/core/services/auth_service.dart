import 'dart:convert';
import 'package:http/http.dart' as http;
import '../network/api_config.dart';
import 'api_service.dart';

class AuthService {
  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');
    try {
      final response = await http
          .post(
            url,
            headers: ApiConfig.headers(),
            body: jsonEncode({
              'email': email.trim().toLowerCase(),
              'password': password,
            }),
          )
          .timeout(ApiConfig.timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (data['data'] != null && data['data']['accessToken'] != null) {
          _accessToken = data['data']['accessToken'];
          ApiService.setToken(_accessToken);
        }
        return {
          'success': true,
          'message': data['message'] ?? 'Logged in successfully',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to connect to backend server: $e',
        'isConnectionError': true,
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String firmName,
    String? phone,
    String? city,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/register');
    try {
      final response = await http
          .post(
            url,
            headers: ApiConfig.headers(),
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'firmName': firmName,
              if (phone != null && phone.isNotEmpty) 'phone': phone,
              if (city != null && city.isNotEmpty) 'city': city,
            }),
          )
          .timeout(ApiConfig.timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Unable to connect to backend server: $e',
        'isConnectionError': true,
      };
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/forgot-password');
    try {
      final response = await http
          .post(
            url,
            headers: ApiConfig.headers(),
            body: jsonEncode({'email': email}),
          )
          .timeout(ApiConfig.timeout);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'message': data['message'] ?? 'Request processed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }
}
