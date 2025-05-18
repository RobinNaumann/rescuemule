import 'dart:convert';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_sent_ids_service.dart';
import 'package:rescuemule/service/s_user_service.dart';
import 'package:rescuemule/view/v_message_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

final messageService = MessageService();

class MessageService {

  static const String _storageKey = 'saved_messages';
  //for performance reasons, could use two keys "buffered_messages" and "stored_messages"
  //own messages buffered first, stored if older than 2 days
  //other messages only buffered
  //messages with us as receiver are stored
  UserService userService = UserService();

  Future<void> saveMessage(Message msg) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> messages = prefs.getStringList(_storageKey) ?? [];
    if(! await isMessageAlreadySeen(msg)){
      messages.add(jsonEncode(msg.toJson()));
      logger.d(this, 'Message saved: ${msg.id}');
    } else {
      logger.d(this, 'Message already seen: ${msg.id}');
    }
    await prefs.setStringList(_storageKey, messages);
  }

  Future<bool> isMessageAlreadySeen(Message msg) async {
    final messages = await loadMessages();
    return messages.any((savedMsg) => savedMsg.id == msg.id);
  }

  Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> messages = prefs.getStringList(_storageKey) ?? [];

    return messages
        .map((msgString) => Message.fromJson(jsonDecode(msgString)))
        .toList();
  }

  Future<List<Message>> loadMessagesForChat(String contact) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> messageStrings = prefs.getStringList(_storageKey) ?? [];

    List<Message> messages =
        messageStrings
            .map((msgString) => Message.fromJson(jsonDecode(msgString)))
            .toList();

    List<Message> messagesWithContact = List.empty(growable: true);

    for (var message in messages) {
      if (message.receiver == contact || message.sender == contact) {
        messagesWithContact.add(message);
      }
    }

    return messagesWithContact;
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> clearBuffer() async {
    final prefs = await SharedPreferences.getInstance();
    final allMessages = await loadMessages();
    final bufferedMessages = await getBufferedMessages();

    // Remove buffered messages from allMessages
    final bufferedIds = bufferedMessages.map((msg) => msg.id).toSet();
    final updatedMessages = allMessages
        .where((msg) => !bufferedIds.contains(msg.id))
        .map((msg) => jsonEncode(msg.toJson()))
        .toList();

    await prefs.setStringList(_storageKey, updatedMessages);
  }

  Future<List<Message>> getMessagesToSend(String deviceID) async {
    final List<int> alreadySentIDs = await sentIDsService.loadSentIDs(deviceID);

    List<Message> messages = List.empty(growable: true);
    final result = await loadMessages();

    messages = result.where((msg) => !alreadySentIDs.contains(msg.id)).toList();
    List<Message> messagesToSend = List.empty(growable: true);
    for (var msg in messages) {
      //at this point has to be done for every discovered device
      if (msg.receiver != await userService.loadUser() &&
          msg.creationTime.isAfter(
            DateTime.now().subtract(const Duration(days: 2)),
          )) {
        messagesToSend.add(msg);
      }
    }

    return messagesToSend;
  }

  Future<void> removeExpiredMessages() async {
    final prefs = await SharedPreferences.getInstance();
    List<Message> messageList = await loadMessages();

    List<int> expiredIDs = List.empty(growable: true);
    //only remove old messages if we dont want to display them, ids can be removed from usermaps anyways
    for (var msg in messageList) {
      if (msg.creationTime.isBefore(DateTime.now().subtract(const Duration(days: 2)))){
        if(!( msg.receiver == await userService.loadUser() || msg.sender == await userService.loadUser())){
          messageList.remove(msg);
        }
        expiredIDs.add(msg.id);
      }
    }
    for (var id in expiredIDs) {
      sentIDsService.removeExpiredID(id);
    }
    final List<String> updatedMessages =
        messageList.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList(_storageKey, updatedMessages);
  }

  Future<List<Message>> getMessagesBetweenUsers(String userB) async {
    UserService userService = UserService();
    final String? userA = await userService.loadUser();
    final messages = await loadMessages();
    return messages
        .where(
          (msg) =>
              (msg.sender == userA && msg.receiver == userB) ||
              (msg.sender == userB && msg.receiver == userA),
        )
        .toList();
  }

  /// Returns all messages that would be sent (like getMessagesToSend) but without filtering by device.
  Future<List<Message>> getBufferedMessages() async {
    final result = await loadMessages();
    final String? currentUser = await userService.loadUser();

    return result.where((msg) =>
      msg.receiver != currentUser &&
      msg.creationTime.isAfter(DateTime.now().subtract(const Duration(days: 2)))
    ).toList();
  }
}
