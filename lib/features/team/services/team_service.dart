import 'package:flutter/foundation.dart';
import '../../../core/services/api_service.dart';
import '../models/team_member_model.dart';

class TeamService extends ValueNotifier<List<TeamMemberModel>> {
  TeamService._() : super([]);

  static final TeamService instance = TeamService._();

  Future<void> fetchTeamFromBackend() async {
    try {
      String? firmId;
      try {
        final profileRes = await ApiService.getMe();
        if (profileRes['success'] == true && profileRes['data'] != null) {
          final profileData = profileRes['data'] as Map<String, dynamic>;
          final teamProf = profileData['teamProfile'] as Map<String, dynamic>?;
          firmId = teamProf?['firmId']?.toString() ??
              profileData['firmId']?.toString() ??
              profileData['id']?.toString();
        }
      } catch (_) {}

      final response = await ApiService.getUsers(firmId: firmId);
      if (response['success'] == true && response['data'] != null) {
        List rawList = [];
        if (response['data'] is List) {
          rawList = response['data'] as List;
        } else if (response['data'] is Map && response['data']['users'] is List) {
          rawList = response['data']['users'] as List;
        }

        final memberList = rawList
            .map((json) => TeamMemberModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Preserve any local members added in session
        final localOnly = value.where((localMem) =>
          !memberList.any((apiMem) => apiMem.id == localMem.id || (apiMem.email.isNotEmpty && apiMem.email == localMem.email))
        ).toList();

        value = [...memberList, ...localOnly];
      }
    } catch (e) {
      debugPrint('Failed to fetch team users from database API: $e');
    }
  }

  void addMember(TeamMemberModel member) {
    value = [member, ...value];
  }

  void updateMember(TeamMemberModel updatedMember) {
    value = value.map((m) => m.id == updatedMember.id ? updatedMember : m).toList();
  }

  void deleteMember(String id) {
    value = value.where((m) => m.id != id).toList();
  }
}
