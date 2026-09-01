import 'package:flutter/foundation.dart';
import '../models/client_model.dart';

class ClientService extends ValueNotifier<List<ClientModel>> {
  ClientService._()
      : super([
          ClientModel(
            id: '1',
            name: 'Hamad Client',
            type: 'Individual',
            cnic: '34201-8787378-2',
            phone: '03087878228',
            email: 'lioness99999999@gmail.com',
            city: 'Lahore',
            status: 'Active',
          ),
          ClientModel(
            id: '2',
            name: 'Arooj Client',
            type: 'Individual',
            cnic: '34989-2989898-9',
            phone: '03098383388',
            email: 'mhamadansari228@gmail.com',
            city: 'Lahore',
            status: 'Active',
          ),
          ClientModel(
            id: '3',
            name: 'Muhammad Ali',
            type: 'Individual',
            cnic: '35202-1234567-1',
            phone: '03087676667',
            email: 'mahnoorakhtaransari999@gmail.com',
            city: 'Karachi',
            status: 'Active',
          ),
        ]);

  static final ClientService instance = ClientService._();

  void addClient(ClientModel client) {
    value = [client, ...value];
  }
}
