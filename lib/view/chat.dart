import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' show InMemoryChatController, TextMessage, User, UserID;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_message_service.dart';

class MyChat extends StatefulWidget {
  final String contact;

  const MyChat({super.key, required this.contact});


  @override
  MyChatState createState() => MyChatState(contact);
}

class MyChatState extends State<MyChat> {
  final _chatController = InMemoryChatController();
  final MessageService messageService = MessageService();
  final String contact;

  MyChatState(this.contact);

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    messageService.loadMessagesForChat(contact).then((messageList){
      for (var message in messageList){
        _chatController.insertMessage(message.toTextMessage());
      }
    });

    return Scaffold(
      body: Chat(
        chatController: _chatController,
        currentUserId: 'ich',
        onMessageSend: (text) {
          Message newMessage = Message.createMessage(sender: 'ich', receiver: contact, message: text);

          messageService.saveMessage(newMessage);
          _chatController.insertMessage(
            newMessage.toTextMessage()
          );
        },
        resolveUser: (UserID id) async {
          return User(id: id, name: 'Andi Scheuerl ist 1 Pimmel');
        },
      ),
    );
  }
}