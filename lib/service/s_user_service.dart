import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _userKey = 'saved_user';
  static const String _contactsKey = 'saved_contacts';

  Future<void> saveUser(String user) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userKey, user);
  }

  Future<String?> loadUser() async {

    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getString(_userKey);
  }

  Future<void> saveContact(String contact) async {

    final prefs = await SharedPreferences.getInstance();
    final List<String> contacts = prefs.getStringList(_contactsKey) ?? [];

    contacts.add(contact);
    await prefs.setStringList(_contactsKey, contacts);
  }

  Future<List<String>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> contacts = prefs.getStringList(_contactsKey) ?? [];

    return contacts;
  }
}