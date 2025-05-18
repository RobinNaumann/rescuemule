import 'package:elbe/bit/bit/bit.dart';
import 'package:rescuemule/bit/b_example.dart';
import 'package:shared_preferences/shared_preferences.dart';
// abstract class Subscriber{
//   void message();
// }
// class Subscribable{
//   List<Subscriber> subscribers = [];
//   void subscribe(Subscriber subscriber){
//     subscribers.add(subscriber);
//   }
//   void publish(){
//     for(var subscriber in subscribers){
//       subscriber.message();
//     }
//   }
// }

class UserService {
  static const String _userKey = 'saved_user';
  static const String _contactsKey = 'saved_contacts';

  Future<void> saveUser(String user) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, user);
  }

  Future<String?> loadUser() async {

    final prefs = await SharedPreferences.getInstance();
    
    String? user = prefs.getString(_userKey);
    return user;
  }

  Future<void> saveContact(String contact) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> contacts = prefs.getStringList(_contactsKey) ?? [];
    contacts.add(contact);
    await prefs.setStringList(_contactsKey, contacts.toSet().toList());
  }

  Future<List<String>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> contacts = prefs.getStringList(_contactsKey) ?? [];

    return contacts;
  }
}