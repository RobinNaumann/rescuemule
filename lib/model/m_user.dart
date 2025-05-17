class User {
  final String name;

  User({required this.name});

  static User createUser({required String name}) {
    return User(name: name);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
      );

  int get id => name.hashCode;
}