import 'dart:convert';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/model/m_user.dart';
import 'package:rescuemule/service/s_sent_ids_service.dart';
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

  Future<List<Message>> getMessagesToSend(UUID deviceID) async {

    SentIDsService service = SentIDsService();
    final List<int> alreadySentIDs = await service.loadSentIDs(deviceID);

    List<Message> messages = List.empty(growable: true);
    loadMessages().then((result) => {
      messages = result.where((msg) => !alreadySentIDs.contains(msg.id)).toList()
    });
    List<Message> messagesToSend = List.empty(growable: true);
    for (var msg in messages) {
        //at this point has to be done for every discovered device
        if(msg.receiver != debugName && msg.creationTime.isAfter(DateTime.now().subtract(const Duration(days: 2)))) {
          messagesToSend.add(msg);
        }
      }
    

    return messagesToSend;
  }
  Future<void> removeExpiredMessages() async {
      final prefs = await SharedPreferences.getInstance();
      List<Message> messageList = List.empty(growable: true);
      loadMessages().then((result) => {
        messageList = result
      }); 
      List<int> expiredIDs = List.empty(growable: true);
      for(var msg in messageList) {
        if(msg.creationTime.isBefore(DateTime.now().subtract(const Duration(days: 2)))) {
          expiredIDs.add(msg.id);
          messageList.remove(msg);
        }
      }
      for(var id in expiredIDs) {
        SentIDsService service = SentIDsService();
        service.removeExpiredID(id);
      }
      final List<String> updatedMessages = messageList.map((msg) => jsonEncode(msg.toJson())).toList();
      await prefs.setStringList(_storageKey, updatedMessages);
  }

  Future<List<Message>> getMessagesBetweenUsers(String userB) async {
    final messages = await loadMessages();
    return messages.where((msg) =>
      (msg.sender == "ich" && msg.receiver == userB) ||
      (msg.sender == userB && msg.receiver == "ich")
    ).toList();
  }
}