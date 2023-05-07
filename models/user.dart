class User {
  User({
    required this.bio,
    required this.gender,
    required this.profession,
    required this.profilePic,
    required this.school,
    required this.uid,
    required this.userName,
  });

  String profilePic;
  String profession;
  String gender;
  String bio;
  String school;
  String userName;
  String uid;

  Map<String, dynamic> toJson() => {
        'bio': bio,
        'gender': gender,
        'profession': profession,
        'profilePic': profilePic,
        'school': school,
        'userName': userName,
        'uid' : uid
      };

  factory User.fromJson(Map<String, dynamic> value) => User(
        bio: value['bio'] ?? '',
        gender: value['gender'] ?? '',
        profession: value['profession'] ?? '',
        profilePic: value['profilePic'] ?? '',
        school: value['school'] ?? '',
        userName: value['userName'] ?? '',
        uid: value['uid'] ?? ''
      );
}
