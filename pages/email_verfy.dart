import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_chat/themes/themes.dart';
import 'package:project_chat/widgets/custom_alerts.dart';

class EmailVirfy extends StatefulWidget {
  const EmailVirfy({super.key});

  @override
  State<EmailVirfy> createState() => _EmailVirfyState();
}

class _EmailVirfyState extends State<EmailVirfy> {
  Timer? timer;
  final _auth = FirebaseAuth.instance;
  bool isActive = true;

  Future<void> checkVerify() async {
    await _auth.currentUser?.reload();
    if (_auth.currentUser?.emailVerified ?? false) {
      timer?.cancel();

      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  Future<void> sendVerfication() async {
    try {
      await _auth.currentUser?.sendEmailVerification();

      timer =
          Timer.periodic(const Duration(seconds: 3), (timer) => checkVerify());
    } on FirebaseAuthException catch (e) {
      errorSnakbar(context, e.code);
    } catch (e) {
      errorSnakbar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    sendVerfication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email Verification',
          style: TextStyle(
            fontFamily: 'VarelaRound',
            fontWeight: FontWeight.bold,
            color: Themes.textColor,
            fontSize: 20.5,
          ),
        ),
        backgroundColor: Themes.backgroudColor,
        elevation: 6,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
              child: Column(
            children: [
              const Text(
                'A Verification email has sent to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'VarelaRound',
                  fontSize: 16,
                ),
              ),
              Text(
                '${_auth.currentUser?.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'VarelaRound',
                  fontSize: 16,
                ),
              ),
            ],
          )),
          const SizedBox(
            height: 17,
          ),
          Center(
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  if (isActive == true) {
                    setState(() {
                      isActive = false;
                    });
                    timer?.cancel();
                    await sendVerfication();
                    await Future.delayed(const Duration(seconds: 5), () {
                      setState(() {
                        isActive = true;
                      });
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isActive ? Colors.blueAccent : Colors.redAccent,
                ),
                child: const Text(
                  'Resend Verification',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'VarelaRound',
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              timer?.cancel();
              await _auth.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }
}
