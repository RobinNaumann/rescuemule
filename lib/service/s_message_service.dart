import 'dart:convert';
import 'package:rescuemule/model/m_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService {
  static const String _storageKey = 'saved_messages';

  Future<void> saveMessage(Message msg) async {

    final prefs = await SharedPreferences.getInstance();
    final List<String> messages = prefs.getStringList(_storageKey) ?? [];

    messages.add(jsonEncode(msg.toJson()));
    await prefs.setStringList(_storageKey, messages);
  }

  Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> messages = prefs.getStringList(_storageKey) ?? [];

    return messages
        .map((msgString) => Message.fromJson(jsonDecode(msgString)))
        .toList();
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}