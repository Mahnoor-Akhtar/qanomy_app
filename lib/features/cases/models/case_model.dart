class CaseModel {
  final String id;
  final String caseIdNo;
  final String firstParty;
  final String oppositeParty;
  final String courtType;
  final String caseType;
  final List<String> judges;
  final String status;
  final String priority;
  final String remarks;
  final String client;
  final String assignee;
  final bool isFavorite;

  CaseModel({
    required this.id,
    required this.caseIdNo,
    required this.firstParty,
    required this.oppositeParty,
    this.courtType = '',
    this.caseType = '',
    this.judges = const [],
    this.status = 'Open',
    this.priority = 'Normal',
    this.remarks = '',
    this.client = '',
    this.assignee = 'Unassigned',
    this.isFavorite = false,
  });

  String get displayTitle => '$firstParty vs $oppositeParty';
}
