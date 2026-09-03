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

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    final name = '$firstName $lastName'.trim();
    final displayName = name.isNotEmpty ? name : (json['email']?.toString() ?? 'Team Member');
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'T';

    final teamProf = json['teamProfile'] as Map<String, dynamic>?;
    final designation = teamProf?['designation']?.toString() ?? json['designation']?.toString() ?? '';
    final status = teamProf?['status']?.toString() ?? json['status']?.toString() ?? 'ACTIVE';

    final rawCreatedAt = json['createdAt']?.toString();
    String joined = 'Today';
    if (rawCreatedAt != null) {
      final dt = DateTime.tryParse(rawCreatedAt);
      if (dt != null) {
        joined = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      }
    }

    return TeamMemberModel(
      id: json['id']?.toString() ?? '',
      initial: initial,
      name: displayName,
      role: json['role']?.toString().toUpperCase() ?? 'LAWYER',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      designation: designation,
      status: status,
      joined: joined,
    );
  }
}
