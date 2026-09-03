import 'dart:convert';
import 'package:http/http.dart' as http;
import '../network/api_config.dart';

class ApiService {
  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static String? get token => _token;

  // Generic Request Helper matching frontend/src/lib/api.ts behavior
  static Future<Map<String, dynamic>> request(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    Uri uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      final headers = ApiConfig.headers(token: _token);
      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(uri, headers: headers, body: jsonEncode(body ?? {})).timeout(ApiConfig.timeout);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: jsonEncode(body ?? {})).timeout(ApiConfig.timeout);
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: jsonEncode(body ?? {})).timeout(ApiConfig.timeout);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(ApiConfig.timeout);
          break;
        case 'GET':
        default:
          response = await http.get(uri, headers: headers).timeout(ApiConfig.timeout);
          break;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return {
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'statusCode': response.statusCode,
        'message': data['message'] ?? 'Operation completed',
        'data': data['data'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'API Request failed: $e',
        'isConnectionError': true,
      };
    }
  }

  // --- CASES ---
  static Future<Map<String, dynamic>> getCases({String? status, String? search}) async {
    final query = <String, String>{};
    if (status != null) query['status'] = status;
    if (search != null) query['search'] = search;
    return request('/cases', queryParams: query);
  }

  static Future<Map<String, dynamic>> getCaseById(String caseId) async {
    return request('/cases/$caseId');
  }

  static Future<Map<String, dynamic>> createCase(Map<String, dynamic> caseData) async {
    return request('/cases', method: 'POST', body: caseData);
  }

  // --- CLIENTS ---
  static Future<Map<String, dynamic>> getClients({String? search}) async {
    final query = <String, String>{};
    if (search != null) query['search'] = search;
    return request('/clients', queryParams: query);
  }

  static Future<Map<String, dynamic>> createClient(Map<String, dynamic> clientData) async {
    return request('/clients', method: 'POST', body: clientData);
  }

  static Future<Map<String, dynamic>> updateClient(String id, Map<String, dynamic> clientData) async {
    return request('/clients/$id', method: 'PUT', body: clientData);
  }

  static Future<Map<String, dynamic>> deleteClient(String id) async {
    return request('/clients/$id', method: 'DELETE');
  }

  // --- HEARINGS ---
  static Future<Map<String, dynamic>> getHearings() async {
    return request('/hearings');
  }

  static Future<Map<String, dynamic>> getUpcomingHearings() async {
    return request('/hearings/upcoming');
  }

  // --- DOCUMENTS ---
  static Future<Map<String, dynamic>> getDocuments({String? caseId}) async {
    final query = <String, String>{};
    if (caseId != null) query['caseId'] = caseId;
    return request('/documents', queryParams: query);
  }

  // --- INVOICES ---
  static Future<Map<String, dynamic>> getInvoices({String? clientId}) async {
    final query = <String, String>{};
    if (clientId != null) query['clientId'] = clientId;
    return request('/invoices', queryParams: query);
  }

  // --- AUTH / ME ---
  static Future<Map<String, dynamic>> getMe() async {
    return request('/auth/me');
  }

  // --- USERS / TEAM ---
  static Future<Map<String, dynamic>> getUsers({String? firmId}) async {
    final query = <String, String>{};
    if (firmId != null && firmId.isNotEmpty) query['firmId'] = firmId;
    return request('/users', queryParams: query);
  }

  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    return request('/users', method: 'POST', body: userData);
  }

  static Future<Map<String, dynamic>> updateUser(String id, Map<String, dynamic> userData) async {
    return request('/users/$id', method: 'PUT', body: userData);
  }

  static Future<Map<String, dynamic>> deleteUser(String id) async {
    return request('/users/$id', method: 'DELETE');
  }

  // --- NOTIFICATIONS ---
  static Future<Map<String, dynamic>> getNotifications() async {
    return request('/notifications?limit=50');
  }
}
