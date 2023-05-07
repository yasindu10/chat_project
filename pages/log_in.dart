import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/auth/controller/auth_controller.dart';
import 'package:project_chat/widgets/custom_buttons.dart';
import 'package:project_chat/widgets/custom_inputs.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    Text(
                      "Friends",
                      style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[100]),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Login now to see what they are Chat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'VarelaRound',
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      hintText: 'Enter your password',
                      textInputType: TextInputType.visiblePassword,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    AuthButton(
                        onCall: () async {
                          await ref.read(authController).logIn(
                              _emailController.text,
                              _passwordController.text,
                              context);
                        },
                        title: 'Log In'),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage("images/g-logo.png"),
                              height: 30.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Log in with Google',
                                style: TextStyle(
                                  fontFamily: 'VarelaRound',
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            'Dont have an account?',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'VarelaRound',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                              context, '/signup', (route) => false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              ' Sign up',
                              style: TextStyle(
                                fontFamily: 'VarelaRound',
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
