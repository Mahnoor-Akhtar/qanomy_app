import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../models/client_model.dart';

class ClientService extends ValueNotifier<List<ClientModel>> {
  ClientService._() : super([]);

  static final ClientService instance = ClientService._();

  Future<void> fetchClientsFromBackend() async {
    try {
      final response = await ApiService.getClients();
      if (response['success'] == true && response['data'] != null) {
        List rawList = [];
        if (response['data'] is List) {
          rawList = response['data'] as List;
        } else if (response['data'] is Map && response['data']['clients'] is List) {
          rawList = response['data']['clients'] as List;
        }

        final clientList = rawList
            .map((json) => ClientModel.fromJson(json as Map<String, dynamic>))
            .toList();
        value = clientList;
      }
    } catch (e) {
      debugPrint('Failed to fetch clients from database API: $e');
    }
  }

  void addClient(ClientModel client) {
    value = [client, ...value];
  }

  void updateClient(ClientModel updatedClient) {
    value = value.map((c) => c.id == updatedClient.id ? updatedClient : c).toList();
  }

  void deleteClient(String id) {
    value = value.where((c) => c.id != id).toList();
  }
}
