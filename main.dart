import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/auth/controller/auth_controller.dart';
// import 'package:project_chat/firebase_options.dart';
import 'package:project_chat/pages/level_up.dart';
import 'package:project_chat/pages/log_in.dart';
import 'package:project_chat/pages/profile.dart';
import 'package:project_chat/pages/sign_up.dart';
import 'package:project_chat/providers/user_provider.dart';
import 'pages/email_verfy.dart';
import 'pages/home_page.dart';
import 'pages/norification.dart';
import 'themes/themes.dart';
import 'widgets/custom_alerts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Friends',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Themes.backgroudColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                return MyApp();
              } else {
                return EmailVirfy();
              }
            } else {
              return LoginScreen();
            }
          },
        ),
        routes: {
          '/signup': (context) => const SignupScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MyApp(),
          '/verfy': (context) => const EmailVirfy()
        },
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  int _currentSelection = 0;
  bool _isLoading = false;

  // current app bar title
  String title = 'Friends';

  // navigation pages
  List<Widget> pages = const [
    HomePage(),
    ProfilePage(),
    Notifications(),
    Levels(),
  ];

  // list of button bav bar items
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home_rounded,
          color: Colors.white60,
        ),
        label: ''),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.person_rounded,
        color: Colors.white60,
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.notifications_rounded,
        color: Colors.white60,
      ),
      label: '',
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.move_up_rounded,
          color: Colors.white60,
        ),
        label: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserDataProvider).when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            elevation: 6,
            backgroundColor: Themes.subBackgroudColor,
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'VarelaRound',
                fontWeight: FontWeight.bold,
                color: Themes.textColor,
                fontSize: 20.5,
              ),
            ),
            actions: [
              (_currentSelection == 1 || _currentSelection == 0)
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          title = 'Profile';
                          _currentSelection = 2;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-fff2lftqIE077pFAKU1Mhbcj8YFvBbMvpA&usqp=CAU',
                          ),
                        ),
                      ),
                    ),
              (_currentSelection == 1)
                  ? IconButton(
                      onPressed: () async {
                        await ref.read(authController).signOut();
                      },
                      icon: const Icon(Icons.logout),
                    )
                  : const SizedBox(),
              (_currentSelection == 0)
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : pages[_currentSelection],
          floatingActionButton: _currentSelection != 0
              ? const SizedBox()
              :
              ///// create group btn
              FloatingActionButton(
                  onPressed: () {
                    showGroupCreater(context, ref);
                  },
                  backgroundColor: const Color.fromARGB(232, 46, 44, 44),
                  elevation: 8,
                  child: const Icon(
                    Icons.group_add_rounded,
                    color: Colors.white,
                  ),
                ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            iconSize: 25,
            elevation: 2000,
            type: BottomNavigationBarType.fixed, // Fixed
            backgroundColor:
                Themes.subBackgroudColor, // <-- This works for fixed
            currentIndex: _currentSelection,
            selectedLabelStyle: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
            items: List<BottomNavigationBarItem>.from(items.map((e) => e)),
            fixedColor: Colors.white,
            onTap: (index) {
              // catch name
              switch (index) {
                case 0:
                  title = 'Friends';
                  break;
                case 1:
                  title = 'Profile';
                  break;
                case 2:
                  title = 'Notifications';
                  break;
                case 3:
                  title = 'Levels';
                  break;
              }

              setState(() {
                _currentSelection = index;
              });
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
