import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/groups/controller/group_controller.dart';
import 'package:project_chat/services/firebase_services.dart';
import 'custom_inputs.dart';

void deleteMsg(
    {required context, required String groupId, required String msgId}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Delete Message for everyone'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseService.groups
                  .doc(groupId)
                  .collection('chats')
                  .doc(msgId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}

void errorSnakbar(context, String name) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
      content: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'VarelaRound',
        ),
      ),
    ),
  );
}

Future<void> showGroupCreater(BuildContext context, WidgetRef ref) async {
  TextEditingController groupname = TextEditingController();
  TextEditingController dics = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Create Group'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldInput(
            textEditingController: groupname,
            hintText: 'Enter group name',
            textInputType: TextInputType.name,
          ),
          const SizedBox(height: 13),
          TextFieldInput(
            textEditingController: dics,
            hintText: 'Enter group discription',
            textInputType: TextInputType.name,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            dics.clear();
            groupname.clear();
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(groupController).createGroup(
                discription: dics.text, name: groupname.text, ref: ref);
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}
