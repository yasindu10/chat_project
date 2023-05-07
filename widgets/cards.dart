import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_chat/pages/chat_view.dart';
import 'package:project_chat/pages/group_details.dart';
import 'package:project_chat/pages/home_page.dart';
import 'package:project_chat/themes/themes.dart';
import 'package:project_chat/models/user.dart' as usermodel;
import 'package:project_chat/models/group.dart' as groupmodel;

Widget userCard(
        {required BuildContext context,
        required usermodel.User user,
        required groupmodel.Group group}) =>
    InkWell(
      onTap: () {},
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: user.profilePic == ''
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('images/noProfile.jpg'),
                      )
                    : CircleAvatar(
                        // radius: 22,
                        backgroundImage: NetworkImage(
                          user.profilePic,
                        ),
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        user.userName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'VarelaRound',
                          color: Themes.textColor,
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                      child: Text(
                        user.bio,
                        style: const TextStyle(
                          color: Themes.textColor,
                          fontFamily: 'VarelaRound',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: user.uid == group.owner
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: ClipOval(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  color: Colors.blueAccent,
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          )
                        ],
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );

// group card
Widget groupCard({required groupmodel.Group group, required context}) =>
    InkWell(
      onTap: () {
        if (group.members.contains(FirebaseAuth.instance.currentUser?.uid)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(group: group),
              ));
        }
      },
      onDoubleTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Color.fromARGB(26, 255, 250, 250),
            content: Text(
              "Sorry you can't watch this group",
              style: TextStyle(
                color: Colors.white,
              ),
            )));
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: group.image == ''
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('images/noProfile.jpg'),
                      )
                    : CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          group.image,
                        ),
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        group.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'VarelaRound',
                          color: Themes.textColor,
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                      child: Text(
                        group.discription,
                        style: const TextStyle(
                          color: Themes.textColor,
                          fontFamily: 'VarelaRound',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: ClipOval(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          color: Colors.blueAccent,
                          child: Center(
                            child: Icon(
                              group.members.contains(
                                      FirebaseAuth.instance.currentUser?.uid)
                                  ? Icons.lock_open_rounded
                                  : Icons.lock_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

// profile page card
Widget profileCard(
        String? profilePic, String name, String disc, IconData icon) =>
    ListTile(
      onTap: () {},
      leading: profilePic == null
          ? ClipOval(
              child: Image.asset('images/noProfile.jpg'),
            )
          : CircleAvatar(
              // radius: 25,
              backgroundImage: NetworkImage(profilePic),
            ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'VarelaRound',
        ),
      ),
      subtitle: Text(
        disc,
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'VarelaRound',
        ),
      ),
      // male or femail
      trailing: Icon(icon),
    );

Widget profileInfoCard(IconData icon, String title, String value) => ListTile(
      leading: CircleAvatar(
        backgroundColor: Themes.backgroudColor,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'VarelaRound',
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'VarelaRound',
        ),
      ),
      onTap: () {},
    );

Widget notificationCard(String title, String content) => ListTile(
      trailing: CircleAvatar(
        backgroundColor: Themes.backgroudColor,
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
        ),
      ),
      minVerticalPadding: 10,
      onTap: () {},
      leading: const CircleAvatar(
        backgroundColor: Themes.backgroudColor,
        child: Icon(
          Icons.notifications_rounded,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'VarelaRound',
        ),
      ),
      subtitle: Text(
        content,
        style: const TextStyle(
          fontSize: 15,
          fontFamily: 'VarelaRound',
        ),
      ),
    );
