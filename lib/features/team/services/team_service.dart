import 'package:flutter/foundation.dart';
import '../models/team_member_model.dart';

class TeamService extends ValueNotifier<List<TeamMemberModel>> {
  TeamService._()
      : super([
          TeamMemberModel(
            id: '1',
            initial: 'F',
            name: 'Fatima',
            role: 'LAWYER',
            email: 'noorlioness999@gmail.com',
            phone: '03076362440',
            status: 'ACTIVE',
            joined: '13/08/2026',
          ),
          TeamMemberModel(
            id: '2',
            initial: 'A',
            name: 'Asim',
            role: 'CLERK',
            email: 'qanomy8@gmail.com',
            phone: '03076962440',
            status: 'ACTIVE',
            joined: '10/08/2026',
          ),
          TeamMemberModel(
            id: '3',
            initial: 'E',
            name: 'Ejaz',
            role: 'LAWYER',
            email: 'ayesha.ansari12098@gmail.com',
            phone: '03078362440',
            status: 'ACTIVE',
            joined: '10/08/2026',
          ),
          TeamMemberModel(
            id: '4',
            initial: 'H',
            name: 'Haris khan',
            role: 'OWNER',
            email: 'mahnoorakhtar002@gmail.com',
            phone: '03051180621',
            status: 'ACTIVE',
            joined: '07/08/2026',
          ),
        ]);

  static final TeamService instance = TeamService._();

  void addMember(TeamMemberModel member) {
    value = [member, ...value];
  }
}
