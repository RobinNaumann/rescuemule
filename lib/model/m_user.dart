import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';

class User {
  final String name;
  UUID? uuid;

  User({required this.name});

  static User createUser({required String name, UUID? uuid}) {
    if (uuid != null) {
      return User(name: name)..uuid = uuid;
    }
    return User(name: name);
  }
  
  Map<String, dynamic> toJson() => {
        'name': name,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
      );

  int get id => name.hashCode;

  void setUUID(UUID uuid) {
    this.uuid = uuid;
  }
}