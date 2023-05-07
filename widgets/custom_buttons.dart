import 'package:flutter/material.dart';
import 'package:project_chat/themes/themes.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.onCall, required this.title});

  final String title;
  final Function() onCall;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCall,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          color: Themes.blueColor,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'VarelaRound',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
