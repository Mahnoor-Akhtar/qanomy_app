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
}
