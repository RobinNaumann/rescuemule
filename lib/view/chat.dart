import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart'
    show InMemoryChatController, User, UserID;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_user_service.dart';
import 'package:rescuemule/view/vp_home.dart';

class MyChat extends StatefulWidget {
  final String contact;

  const MyChat({super.key, required this.contact});

  @override
  MyChatState createState() => MyChatState(contact);
}

class MyChatState extends State<MyChat> {
  final _chatController = InMemoryChatController();
  final String contact;
  final UserService userService =  UserService();
  String? user;

  MyChatState(this.contact);

    
  @override
  void initState() {
    super.initState();
    userService.loadUser().then((onValue){
      setState(() {
        user = onValue;
      });
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null){
      return const Center(child: CircularProgressIndicator());
    }
    messageService.getMessagesBetweenUsers(contact).then((messageList){
      for (var message in messageList){
        _chatController.insertMessage(message.toTextMessage());
      }
    });
    return Scaffold(
      body: Chat(
        chatController: _chatController,
        currentUserId: user??"dummy3",//TODO fix this uggly as shit
        onMessageSend: (text) {
          Message newMessage = Message.createMessage(
            sender: user??"dummy4",//TODO fix this uggly as shit,
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

class _ChatExampleState extends State<ScaffoldExample> {
  TextEditingController controller = TextEditingController();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Neuer Chat")),
      body: Center(
        child: SizedBox(
          width: 200,
            child:
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (value){
                userService.saveContact(value);
              }
            ),
        ),
      ),
    );
  }
}
