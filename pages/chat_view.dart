import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/groups/controller/group_controller.dart';
import 'package:project_chat/models/msg.dart';
import 'package:project_chat/pages/group_details.dart';
import 'package:project_chat/services/firebase_services.dart';
import 'package:project_chat/themes/themes.dart';
import 'package:project_chat/models/group.dart' as model;
import 'package:project_chat/widgets/chat_title.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    super.key,
    required this.group,
  });

  final model.Group group;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _auth = FirebaseAuth.instance.currentUser;

  late TextEditingController _msgController;

  @override
  void initState() {
    _msgController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        elevation: 6,
        automaticallyImplyLeading: false,
        backgroundColor: Themes.subBackgroudColor,
        flexibleSpace: SafeArea(
          child: GestureDetector(
            onTap: () {
              ref
                  .read(membersProvider.notifier)
                  .update((state) => widget.group.members);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupDetails(group: widget.group),
                  ));
            },
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  widget.group.image == ''
                      ? const CircleAvatar(
                          backgroundImage: AssetImage('images/noProfile.jpg'),
                        )
                      : CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            widget.group.image,
                          ),
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.group.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'VarelaRound',
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.group.discription,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                            fontFamily: 'VarelaRound',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: [
              StreamBuilder(
                stream: FirebaseService.groups
                    .doc(widget.group.id)
                    .collection('chats')
                    .orderBy('stamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final model =
                            Message.fromJson(snapshot.data!.docs[index].data());
                        return MessageTile(
                          msg: model,
                          group: widget.group,
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(83, 0, 0, 0),
                    blurRadius: 15.0,
                    offset: Offset(0.0, 1),
                  )
                ],
                color: Themes.backgroudColor,
              ),
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: Themes.mobileSearchColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.attach_file_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),

                  ////////// Input field
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(
                          fontFamily: 'VarelaRound',
                          color: Colors.white,
                          fontSize: 15.9,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  //////////// send btn
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: FloatingActionButton(
                      onPressed: () async {
                        await ref.read(groupController).sendMsg(
                            groupId: widget.group.id,
                            msgText: _msgController.text,
                            ref: ref);

                        _msgController.clear();
                      },
                      backgroundColor: Themes.mobileSearchColor,
                      elevation: 100,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
