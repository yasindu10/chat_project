import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/groups/controller/group_controller.dart';
import 'package:project_chat/widgets/cards.dart';
import 'package:project_chat/widgets/loading_helperes.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ref.watch(getGroupsProvider).when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => groupCard(
            context: context,
            group: data[index],
          ),
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('error'),
        );
      },
      loading: () {
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemCount: 20,
          itemBuilder: (context, index) => const LoadingHelper(
            color: Color.fromARGB(76, 0, 0, 0),
          ),
        );
      },
    );
  }
}
