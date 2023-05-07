import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/groups/controller/group_controller.dart';
import 'package:project_chat/models/group.dart' as model;
import 'package:project_chat/res/file_sys.dart';
import 'package:project_chat/widgets/cards.dart';
import 'package:project_chat/widgets/loading_helperes.dart';

final membersProvider = StateProvider((ref) => []);

class GroupDetails extends ConsumerStatefulWidget {
  const GroupDetails({super.key, required this.group});

  final model.Group group;

  @override
  ConsumerState<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends ConsumerState<GroupDetails> {
  late TextEditingController _disc;
  // check admin
  bool checkAdmin() {
    if (widget.group.owner == FirebaseAuth.instance.currentUser?.uid) {
      return true;
    } else {
      return false;
    }
  }

  // image file
  File? file;

  @override
  void initState() {
    super.initState();
    _disc = TextEditingController();
    _disc.text = widget.group.discription;
  }

  @override
  void dispose() {
    _disc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      file == null
                          ? widget.group.image == ''
                              ? ClipOval(
                                  child: Image.asset(
                                    'images/noProfile.jpg',
                                    width: 115,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 58,
                                  backgroundImage: NetworkImage(
                                    widget.group.image,
                                  ),
                                )
                          : CircleAvatar(
                              radius: 58,
                              backgroundImage: FileImage(file!),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 67,
                        child: IconButton(
                          onPressed: () async {
                            file = await ref.read(fsProvider).picFile();

                            if (file != null) {
                              setState(() {});
                              ref
                                  .read(groupController)
                                  .changeGroupImage(widget.group.name, file!);
                              ref.refresh(getGroupsProvider.future);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(26, 255, 250, 250),
                                      content: Text(
                                        "No File Selected",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )));
                            }
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            size: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    widget.group.name,
                    style: const TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.group.members.length > 100
                        ? '100+ Group Participants'
                        : widget.group.members.length > 10
                            ? '${widget.group.members.length} Group Participants'
                            : '0${widget.group.members.length} Group Participants',
                    style: const TextStyle(
                      fontFamily: 'VarelaRound',
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(
                    thickness: 7,
                    color: Color.fromARGB(83, 0, 0, 0),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Group Discription',
                              style: TextStyle(
                                fontFamily: 'VarelaRound',
                              ),
                            ),
                          ),
                          TextField(
                            controller: _disc,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'VarelaRound',
                            ),
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white70)),
                              hintText: 'Group Discription',
                              hintStyle: TextStyle(
                                fontFamily: 'VarelaRound',
                              ),
                            ),
                          ),
                        ],
                      )),
                  const Divider(
                    thickness: 7,
                    color: Color.fromARGB(83, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.group.members.length > 9
                        ? '${widget.group.members.length} Participants'
                        : '0${widget.group.members.length} Participants',
                  ),
                  // search Icon
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          // SliverFixedExtentList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) => userCard(
          //         context: context,
          //         bio: users[index].bio,
          //         image: users[index].profilePic,
          //         name: users[index].userName,
          //         uid: users[index].uid,
          //         admin: widget.admin,
          //         ),
          //     childCount: users.length,
          //   ),
          //   itemExtent: 75.5,
          // )
          ref.watch(getGroupMembers).when(
            data: (data) {
              return SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => userCard(
                    context: context,
                    group: widget.group,
                    user: data[index],
                  ),
                  childCount: data.length,
                ),
                itemExtent: 75.5,
              );
            },
            error: (error, stackTrace) {
              return SliverToBoxAdapter(
                ////////////// loading helper
                child: Center(
                    child: Center(
                  child: Text(error.toString()),
                )),
              );
            },
            loading: () {
              return SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const LoadingHelper(
                    color: Color.fromARGB(76, 0, 0, 0),
                  ),
                  childCount: 10,
                ),
                itemExtent: 75.5,
              );
            },
          ),
        ],
      ),
    );
  }
}
