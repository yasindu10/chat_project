import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_chat/models/msg.dart' as model;
import 'package:project_chat/widgets/custom_alerts.dart';
import 'package:project_chat/models/group.dart' as groupmodel;

class MessageTile extends StatefulWidget {
  final model.Message msg;

  const MessageTile({super.key, required this.msg, required this.group});

  final groupmodel.Group group;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  bool checkIsMe() {
    if (FirebaseAuth.instance.currentUser!.uid == widget.msg.senderId) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onLongPress: () {
        if (widget.msg.senderId == auth?.uid ||
            widget.group.owner == auth?.uid) {
          deleteMsg(
              context: context,
              groupId: widget.group.id,
              msgId: widget.msg.msgUid);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 7,
          bottom: 7,
          left: checkIsMe() ? 0 : 24,
          right: checkIsMe() ? 24 : 0,
        ),
        alignment: checkIsMe() ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: checkIsMe()
              ? const EdgeInsets.only(left: 25)
              : const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: checkIsMe()
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
            color: checkIsMe()
                ? Theme.of(context).primaryColor
                : const Color.fromARGB(223, 68, 137, 255),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.msg.sender.toUpperCase(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 10.6,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  fontFamily: 'VarelaRound',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.msg.msg,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 13.7,
                  color: Colors.white,
                  fontFamily: 'VarelaRound',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
