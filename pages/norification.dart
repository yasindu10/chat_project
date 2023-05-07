import 'package:flutter/material.dart';
import 'package:project_chat/widgets/cards.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        notificationCard('House Meet KCC',
            'Congradulations all Thissa house members and fuck all Thissa house members'),
        notificationCard('KCC School web site relese',
            'Today is a good day for students of KCC school becouse Our school website was relesed today')
      ],
    );
  }
}
