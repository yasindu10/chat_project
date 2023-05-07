import 'package:flutter/material.dart';
import 'package:project_chat/themes/themes.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({
    super.key,
    required this.context,
    required this.image,
    required this.name,
    required this.bio,
    required this.uid,
  });

  final BuildContext context;
  final String image;
  final String name;
  final String bio;
  final String uid;

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                child: widget.image == ''
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('images/noProfile.jpg'),
                      )
                    : CircleAvatar(
                        // radius: 22,
                        backgroundImage: NetworkImage(
                          widget.image,
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
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'VarelaRound',
                          color: Themes.textColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                      child: Text(
                        widget.bio,
                        style: const TextStyle(
                          fontFamily: 'VarelaRound',
                          color: Themes.textColor,
                          fontSize: 12,
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
  }
}
