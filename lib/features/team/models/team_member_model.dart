class TeamMemberModel {
  final String id;
  final String initial;
  final String name;
  final String role; // LAWYER, CLERK, OWNER, READ-ONLY
  final String email;
  final String phone;
  final String designation;
  final String status; // ACTIVE, INACTIVE
  final String joined;
  final Map<String, bool> permissions;

  TeamMemberModel({
    required this.id,
    required this.initial,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    this.designation = '',
    this.status = 'ACTIVE',
    required this.joined,
    this.permissions = const {},
  });
}
