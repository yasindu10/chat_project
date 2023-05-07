import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/auth/controller/auth_controller.dart';
import 'package:project_chat/res/file_sys.dart';
import 'package:project_chat/widgets/custom_alerts.dart';
import 'package:project_chat/widgets/custom_buttons.dart';
import 'package:project_chat/widgets/custom_inputs.dart';

enum Genders { male, female }

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _school = TextEditingController();
  File? _file;
  Genders? gender;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Friends",
                        style: TextStyle(
                          fontFamily: 'VarelaRound',
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Share Your Happy Moments',
                        style: TextStyle(
                            fontFamily: 'VarelaRound',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 15),
                      Stack(
                        children: [
                          _file != null
                              ? CircleAvatar(
                                  radius: 53,
                                  backgroundImage: FileImage(_file!),
                                  backgroundColor: Colors.red,
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    'images/noProfile.jpg',
                                    width: 105,
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 70,
                            child: IconButton(
                              onPressed: () async {
                                _file = await ref.watch(fsProvider).picFile();

                                if (_file != null) {
                                  setState(() {});
                                } else {
                                  errorSnakbar(context, 'No File Selected');
                                }
                              },
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 23),
                      TextFieldInput(
                        hintText: 'Enter your Username',
                        textInputType: TextInputType.text,
                        textEditingController: _usernameController,
                      ),
                      const SizedBox(height: 19),
                      TextFieldInput(
                        hintText: 'Enter your Bio',
                        textInputType: TextInputType.text,
                        textEditingController: _bioController,
                      ),
                      const SizedBox(height: 19),
                      TextFieldInput(
                        hintText: 'Enter your Email',
                        textInputType: TextInputType.text,
                        textEditingController: _emailController,
                      ),
                      const SizedBox(height: 19),
                      TextFieldInput(
                        isPass: true,
                        hintText: 'Enter your Password',
                        textInputType: TextInputType.text,
                        textEditingController: _passwordController,
                      ),
                      const SizedBox(height: 19),
                      TextFieldInput(
                        isPass: false,
                        hintText: 'Enter your Profession (ex: Gamer/developer)',
                        textInputType: TextInputType.text,
                        textEditingController: _profession,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Radio(
                            value: Genders.male,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          const Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'VarelaRound',
                            ),
                          ),
                          const SizedBox(width: 92),
                          Radio(
                            value: Genders.female,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          const Text(
                            'Femail',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'VarelaRound',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFieldInput(
                        isPass: false,
                        hintText: 'Enter your School',
                        textInputType: TextInputType.text,
                        textEditingController: _school,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      // button
                      AuthButton(
                        onCall: () async {
                          String finalGender =
                              gender!.index == 0 ? 'male' : 'female';

                          await ref.read(authController).createUser(
                                name: _usernameController.text,
                                gender: finalGender,
                                image: _file!,
                                email: _emailController.text,
                                password: _passwordController.text,
                                profession: _profession.text,
                                school: _school.text,
                                context: context,
                                bio: _bioController.text,
                              );
                        },
                        title: 'Sign Up',
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      InkWell(
                        onTap: () async {},
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Image(
                                image: AssetImage("images/g-logo.png"),
                                height: 30.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Sign Up with Google',
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontFamily: 'VarelaRound',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.8,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false),
                            child: const Text(
                              '  Log in Now',
                              style: TextStyle(
                                fontFamily: 'VarelaRound',
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
