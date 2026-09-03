class ClientModel {
  final String id;
  final String name;
  final String type;
  final String companyName;
  final String ntn;
  final String cnic;
  final String occupation;
  final String phone;
  final String referredBy;
  final String email;
  final String city;
  final String address;
  final String notes;
  final String status;
  final bool portalAccess;

  ClientModel({
    required this.id,
    required this.name,
    required this.type,
    this.companyName = '',
    this.ntn = '',
    required this.cnic,
    this.occupation = '',
    required this.phone,
    this.referredBy = '',
    required this.email,
    this.city = 'Lahore',
    this.address = '',
    this.notes = '',
    this.status = 'Active',
    this.portalAccess = true,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    final name = '$firstName $lastName'.trim();
    final displayName = name.isNotEmpty ? name : (json['name']?.toString() ?? 'Client');
    final profile = json['clientProfile'] as Map<String, dynamic>?;

    return ClientModel(
      id: json['id']?.toString() ?? '',
      name: displayName,
      type: profile?['clientType']?.toString() ?? json['clientType']?.toString() ?? json['type']?.toString() ?? 'Individual',
      companyName: json['companyName']?.toString() ?? '',
      ntn: json['ntn']?.toString() ?? '',
      cnic: profile?['cnic']?.toString() ?? json['cnic']?.toString() ?? '',
      occupation: profile?['occupation']?.toString() ?? json['occupation']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      referredBy: profile?['referredBy']?.toString() ?? json['referredBy']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      city: profile?['city']?.toString() ?? json['city']?.toString() ?? 'Lahore',
      address: profile?['address']?.toString() ?? json['address']?.toString() ?? '',
      notes: profile?['notes']?.toString() ?? json['notes']?.toString() ?? '',
      status: profile?['status']?.toString() ?? json['status']?.toString() ?? 'Active',
      portalAccess: profile?['portalAccess'] == true || json['portalAccess'] == true,
    );
  }
}
