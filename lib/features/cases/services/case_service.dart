import 'package:flutter/foundation.dart';
import '../models/case_model.dart';

class CaseService extends ValueNotifier<List<CaseModel>> {
  CaseService._()
      : super([
          CaseModel(id: '1', caseIdNo: 'Case-2024-001', firstParty: 'Ali', oppositeParty: 'Ahmed', assignee: 'Haris Khan', isFavorite: false),
          CaseModel(id: '2', caseIdNo: 'Case-2024-002', firstParty: 'Ejaz', oppositeParty: 'Adnan', assignee: 'Haris Khan', isFavorite: true),
          CaseModel(id: '3', caseIdNo: 'Case-2024-003', firstParty: 'Alia', oppositeParty: 'Adnan', assignee: 'Fatima', isFavorite: true),
          CaseModel(id: '4', caseIdNo: 'Case-2024-004', firstParty: 'Ali', oppositeParty: 'Babar', assignee: 'Fatima', isFavorite: false),
          CaseModel(id: '5', caseIdNo: 'Case-2024-005', firstParty: 'Momina', oppositeParty: 'Muheeb', assignee: 'Unassigned', isFavorite: true),
          CaseModel(id: '6', caseIdNo: 'Case-2024-006', firstParty: 'Ali', oppositeParty: 'Naveed', assignee: 'Unassigned', isFavorite: false),
        ]);

  static final CaseService instance = CaseService._();

  void addCase(CaseModel caseItem) {
    value = [caseItem, ...value];
  }

  void updateCase(CaseModel updatedCase) {
    value = value.map((c) => c.id == updatedCase.id ? updatedCase : c).toList();
  }

  void deleteCase(String id) {
    value = value.where((c) => c.id != id).toList();
  }

  void toggleFavorite(String id) {
    value = value.map((c) {
      if (c.id == id) {
        return CaseModel(
          id: c.id,
          caseIdNo: c.caseIdNo,
          firstParty: c.firstParty,
          oppositeParty: c.oppositeParty,
          courtType: c.courtType,
          caseType: c.caseType,
          judges: c.judges,
          status: c.status,
          priority: c.priority,
          remarks: c.remarks,
          client: c.client,
          assignee: c.assignee,
          isFavorite: !c.isFavorite,
        );
      }
      return c;
    }).toList();
  }
}
