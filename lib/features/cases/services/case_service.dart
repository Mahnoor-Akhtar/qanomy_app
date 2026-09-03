import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../models/case_model.dart';

class CaseService extends ValueNotifier<List<CaseModel>> {
  CaseService._() : super([]);

  static final CaseService instance = CaseService._();

  Future<void> fetchCasesFromBackend({String? search, String? status}) async {
    try {
      final response = await ApiService.getCases(search: search, status: status);
      if (response['success'] == true && response['data'] != null) {
        List rawList = [];
        if (response['data'] is List) {
          rawList = response['data'] as List;
        } else if (response['data'] is Map && response['data']['cases'] is List) {
          rawList = response['data']['cases'] as List;
        }

        final casesList = rawList
            .map((json) => CaseModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Preserve any locally added cases not yet in backend response
        final localOnly = value.where((localCase) =>
          !casesList.any((apiCase) => apiCase.id == localCase.id || apiCase.caseIdNo == localCase.caseIdNo)
        ).toList();

        value = [...casesList, ...localOnly];
      } else {
        debugPrint('Cases fetch warning (${response['statusCode']}): ${response['message']}');
      }
    } catch (e) {
      debugPrint('Failed to fetch cases from database API: $e');
    }
  }

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
          hearingDate: c.hearingDate,
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
