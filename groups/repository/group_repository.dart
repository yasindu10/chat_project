import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/groups/controller/group_controller.dart';
import 'package:project_chat/models/group.dart';
import 'package:project_chat/providers/user_provider.dart';
import 'package:project_chat/services/firebase_services.dart';
import 'package:project_chat/models/user.dart' as usermodel;
import 'package:project_chat/models/msg.dart' as msgmodel;
import 'package:project_chat/models/group.dart' as groupmodel;

final groupReposiroty = Provider((ref) => GroupRepository());

class GroupRepository {
  final _auth = FirebaseAuth.instance;

  Future<void> createGroup({
    required String discription,
    required String image,
    required String name,
    required WidgetRef ref,
  }) async {
    final doc = FirebaseService.groups.doc();

    groupmodel.Group group = groupmodel.Group(
      discription: discription,
      id: doc.id,
      image: image,
      members: [_auth.currentUser!.uid],
      name: name,
      // owner is an id
      owner: _auth.currentUser!.uid,
    );

    doc.set(group.toJson());
    ref.refresh(getGroupsProvider.future);
  }

  Future<List<Group>> getGroups() async {
    final group = await FirebaseService.groups.get();

    List<Group> groups =
        List.from(group.docs.map((e) => Group.fromJson(e.data())));

    return groups;
  }

  Future<List<usermodel.User>> getGroupMembers(List members) async {
    List<usermodel.User> users = [];

    for (var user in members) {
      final userSnap = await FirebaseService.accounts.doc(user).get();
      users.add(usermodel.User.fromJson(userSnap.data()!));
    }

    return users;
  }

  Future<void> sendMessage(
      {required String groupId,
      required String msgText,
      required WidgetRef ref}) async {
    final doc = FirebaseService.groups.doc(groupId).collection('chats').doc();

    msgmodel.Message msgMo = msgmodel.Message(
        msg: msgText,
        sender: ref.read(userProvider).user!.userName,
        msgUid: doc.id,
        senderId: _auth.currentUser!.uid,
        stamp: Timestamp.now());

    await doc.set(msgMo.toJson());
  }

  Future<void> changeGroupImage(String groupName, File file) async {
    await FirebaseStorage.instance
        .ref()
        .child('groups/$groupName/image')
        .putFile(file);
  }
}
