class Group {
  String name;
  String owner;
  List members;
  String image;
  String discription;
  String id;

  Group(
      {required this.image,
      required this.members,
      required this.name,
      required this.owner,
      required this.discription,
      required this.id});

  Map<String, dynamic> toJson() => {
        'name' : name,
        'owner' : owner,
        'members' : members,
        'image' : image,
        'disc' : discription,
        'id' : id,
      };

  factory Group.fromJson(Map<String, dynamic> data) => Group(
        image: data['image'],
        members: data['members'],
        name: data['name'],
        owner: data['owner'],
        discription: data['disc'],
        id: data['id'],
      );
}
