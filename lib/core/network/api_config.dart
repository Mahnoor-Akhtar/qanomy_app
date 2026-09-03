import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    final configuredUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000/api/v1';

    if (kIsWeb) {
      final currentHost = Uri.base.host;
      if (currentHost == '127.0.0.1' && configuredUrl.contains('localhost')) {
        return configuredUrl.replaceAll('localhost', '127.0.0.1');
      } else if (currentHost == 'localhost' && configuredUrl.contains('127.0.0.1')) {
        return configuredUrl.replaceAll('127.0.0.1', 'localhost');
      }
      return configuredUrl;
    }

    // Auto-adjust localhost IP for Android Emulator safely without dart:io
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (configuredUrl.contains('localhost')) {
        return configuredUrl.replaceAll('localhost', '10.0.2.2');
      }
      if (configuredUrl.contains('127.0.0.1')) {
        return configuredUrl.replaceAll('127.0.0.1', '10.0.2.2');
      }
    }

    return configuredUrl;
  }

  static Duration get timeout {
    final secondsStr = dotenv.env['API_TIMEOUT_SECONDS'] ?? '10';
    return Duration(seconds: int.tryParse(secondsStr) ?? 10);
  }

  static Map<String, String> headers({String? token}) {
    final map = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }
}
