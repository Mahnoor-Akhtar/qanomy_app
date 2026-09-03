class CaseModel {
  final String id;
  final String caseIdNo;
  final String firstParty;
  final String oppositeParty;
  final String courtType;
  final String caseType;
  final List<String> judges;
  final String status;
  final DateTime? hearingDate;
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
    this.status = 'Running',
    this.hearingDate,
    this.priority = 'Normal',
    this.remarks = '',
    this.client = '',
    this.assignee = 'Unassigned',
    this.isFavorite = false,
  });

  String get displayTitle => '$firstParty vs $oppositeParty';

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title']?.toString() ?? '';
    final titleParts = rawTitle.split(' vs ');

    final firstParty = (json['firstParty'] != null && json['firstParty'].toString().trim().isNotEmpty)
        ? json['firstParty'].toString().trim()
        : (titleParts.isNotEmpty && titleParts[0].trim().isNotEmpty
            ? titleParts[0].trim()
            : (json['client']?['firstName']?.toString() ?? 'Party 1'));

    final oppositeParty = (json['oppositeParty'] != null && json['oppositeParty'].toString().trim().isNotEmpty)
        ? json['oppositeParty'].toString().trim()
        : ((json['againstParty'] != null && json['againstParty'].toString().trim().isNotEmpty)
            ? json['againstParty'].toString().trim()
            : (titleParts.length > 1 && titleParts[1].trim().isNotEmpty
                ? titleParts[1].trim()
                : 'Party 2'));

    final clientName = json['client'] != null
        ? '${json['client']['firstName'] ?? ''} ${json['client']['lastName'] ?? ''}'.trim()
        : '';

    final assigneeName = json['assignedLawyer'] != null
        ? '${json['assignedLawyer']['firstName'] ?? ''} ${json['assignedLawyer']['lastName'] ?? ''}'.trim()
        : 'Unassigned';

    DateTime? hearingDate;
    if (json['hearingDate'] != null) {
      hearingDate = DateTime.tryParse(json['hearingDate'].toString());
    } else if (json['createdAt'] != null) {
      hearingDate = DateTime.tryParse(json['createdAt'].toString());
    }

    List<String> judgesList = [];
    if (json['judgeName'] != null && json['judgeName'].toString().trim().isNotEmpty) {
      judgesList = [json['judgeName'].toString().trim()];
    } else if (json['judges'] is List) {
      judgesList = (json['judges'] as List).map((j) => j.toString()).toList();
    }

    return CaseModel(
      id: json['id']?.toString() ?? '',
      caseIdNo: json['caseNumber']?.toString() ?? json['id']?.toString() ?? '',
      firstParty: firstParty,
      oppositeParty: oppositeParty,
      courtType: json['court']?.toString() ?? json['courtType']?.toString() ?? '',
      caseType: json['caseType']?.toString() ?? '',
      judges: judgesList,
      status: json['status']?.toString() ?? 'Running',
      hearingDate: hearingDate,
      priority: json['priority']?.toString() ?? 'Normal',
      remarks: json['description']?.toString() ?? '',
      client: clientName,
      assignee: assigneeName,
      isFavorite: json['isStarred'] == true,
    );
  }
}
