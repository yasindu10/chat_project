import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String msg;
  String msgUid;
  String senderId;
  Timestamp stamp;

  Message(
      {required this.msg,
      required this.sender,
      required this.msgUid,
      required this.senderId,
      required this.stamp});

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'msg': msg,
        'senderId': senderId,
        'stamp': stamp,
        'msgUid': msgUid,
      };

  factory Message.fromJson(Map<String, dynamic> data) => Message(
        msg: data['msg'],
        sender: data['sender'],
        msgUid: data['msgUid'],
        senderId: data['senderId'],
        stamp: Timestamp.now(),
      );
}
