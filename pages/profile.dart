import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_chat/providers/user_provider.dart';
import 'package:project_chat/widgets/cards.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _user = ref.read(userProvider).user;

    return ListView(
      children: [
        profileCard(
          _user?.profilePic,
          _user?.userName ?? "Did't",
          _user?.profession ?? "Did't",
          _user?.gender == "Did't set"
              ? Icons.person_outline
              : (_user?.gender == 'male')
                  ? Icons.person_rounded
                  : Icons.person_2_rounded,
        ),
        profileInfoCard(
          Icons.cast_for_education_rounded,
          'Profession',
          _user?.profession ?? "Did't",
        ),
        profileInfoCard(
          Icons.edit_document,
          'Bio',
          _user?.bio ?? "Did't",
        ),
        profileInfoCard(
          _user?.gender == "Did't set"
              ? Icons.person_outline
              : (_user?.gender == 'male')
                  ? Icons.person_rounded
                  : Icons.person_2_rounded,
          'Gender',
          _user?.gender ?? '',
        ),
        profileInfoCard(
          Icons.school_rounded,
          'School',
          _user?.school ?? '',
        ),
        profileInfoCard(
          Icons.groups,
          'Groups Connected',
          '100+',
        ),
        profileInfoCard(
          Icons.groups,
          'Own Groups',
          '100+',
        ),
      ],
    );
  }
}
