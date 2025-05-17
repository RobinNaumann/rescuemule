import 'dart:convert';
import 'package:elbe/elbe.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/model/m_user.dart';
import 'package:rescuemule/service/s_device_service.dart';
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

  Future<List<Message>> getMessagesToSend(String deviceID) async {

    DeviceService service = DeviceService();
    final List<int> alreadySentIDs = await service.getAlreadySentIDs(deviceID);

    final prefs = await SharedPreferences.getInstance();
    List<Message> messages = List.empty(growable: true);
    loadMessages().then((result) => {
      messages = result.where((msg) => !alreadySentIDs.contains(msg.id)).toList()
    });
    List<Message> messagesToSend = List.empty(growable: true);
    for (var msg in messages) {
        if(msg.receiver != "ich" && msg.creationTime.isAfter(DateTime.now().subtract(const Duration(days: 2)))) {
          messagesToSend.add(msg);
        }
      }
    

    return messagesToSend;
  }
}