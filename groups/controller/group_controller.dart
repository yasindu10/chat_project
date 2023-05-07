import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/groups/repository/group_repository.dart';
import 'package:project_chat/models/group.dart';
import 'package:project_chat/models/user.dart';
import 'package:project_chat/pages/group_details.dart';

final groupController = Provider((ref) {
  final repo = ref.read(groupReposiroty);
  return GroupController(repo: repo);
});

final getGroupsProvider =
    FutureProvider((ref) => ref.read(groupReposiroty).getGroups());

final getGroupMembers = FutureProvider((ref) => ref
    .read(groupController)
    .getGroupMembers(ref.watch(membersProvider.notifier).state));

class GroupController {
  GroupRepository repo;
  GroupController({required this.repo});

  Future<List<Group>> getGroups() async {
    return await repo.getGroups();
  }

  Future<List<User>> getGroupMembers(List members) async {
    return await repo.getGroupMembers(members);
  }

  Future<void> sendMsg(
      {required String groupId,
      required String msgText,
      required WidgetRef ref}) async {
    repo.sendMessage(groupId: groupId, msgText: msgText, ref: ref);
  }

  Future<void> changeGroupImage(String groupName, File file) async {
    repo.changeGroupImage(groupName, file);
  }

  Future<void> createGroup(
      {required String discription,
      required String name,
      required WidgetRef ref}) async {
    return repo.createGroup(
      discription: discription,
      image: '',
      name: name,
      ref: ref,
    );
  }
}
