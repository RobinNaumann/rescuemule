import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart'
    show InMemoryChatController, User, UserID;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_message_service.dart';

class MyChat extends StatefulWidget {
  final String contact;

  const MyChat({super.key, required this.contact});

  @override
  MyChatState createState() => MyChatState();
}

class MyChatState extends State<MyChat> {
  final _chatController = InMemoryChatController();
  final MessageService messageService = MessageService();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    messageService.loadMessagesForChat(widget.contact).then((messageList) {
      for (var message in messageList) {
        _chatController.insertMessage(message.toTextMessage());
      }
    });

    return Scaffold(
      body: Chat(
        chatController: _chatController,
        currentUserId: 'ich',
        onMessageSend: (text) {
          Message newMessage = Message.createMessage(
            sender: 'ich',
            receiver: widget.contact,
            message: text,
          );

          messageService.saveMessage(newMessage);
          _chatController.insertMessage(newMessage.toTextMessage());
        },
        resolveUser: (UserID id) async {
          return User(id: id, name: 'Andi Scheuerl ist 1 Pimmel');
        },
      ),
    );
  }
}

class ChatDetailPage extends StatelessWidget {
  final MyChat myChat;
  const ChatDetailPage({super.key, required this.myChat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(myChat.contact)),
      body: Center(child: myChat),
    );
  }
}
