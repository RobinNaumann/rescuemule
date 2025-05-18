import 'package:elbe/elbe.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_chat_core/flutter_chat_core.dart'
    show InMemoryChatController, User, UserID;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:rescuemule/bit/b_chat.dart';
import 'package:rescuemule/bit/b_example.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_sending_service.dart';
import 'package:rescuemule/service/s_user_service.dart';

class MyChat extends StatelessWidget {
  final String contact;

  const MyChat({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
      create: (_) => ChatBit(contact),
      child: m.Scaffold(
        body: ExampleBit.builder(
          onData:
              (_, userData) => ChatBit.builder(
                onData:
                    (bit, data) => Chat(
                      key: Key(data.hashCode.toString()),
                      chatController: InMemoryChatController(
                        messages:
                            data.messages
                                .map((e) => e.toTextMessage())
                                .toList(),
                      ),
                      currentUserId:
                          userData.user ??
                          "unknown", //TODO fix this uggly as shit
                      onMessageSend: (text) {
                        Message newMessage = Message.createMessage(
                          sender:
                              userData.user ??
                              "unknown", //TODO fix this uggly as shit,
                          receiver: contact,
                          message: text,
                        );

                        bit.addMsg(newMessage);
                      },
                      resolveUser: (UserID id) async {
                        return User(id: id, name: 'Andi Scheuerl ist 1 Pimmel');
                      },
                    ),
              ),
        ),
      ),
    );
  }
}

class ChatDetailPage extends StatelessWidget {
  final MyChat myChat;
  const ChatDetailPage({super.key, required this.myChat});

  @override
  Widget build(BuildContext context) {
    return m.Scaffold(
      appBar: AppBar(title: Text(myChat.contact)),
      body: Center(child: myChat),
    );
  }
}

class ChatExampleApp extends StatelessWidget {
  const ChatExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ChatExample());
  }
}

class ChatExample extends StatefulWidget {
  const ChatExample({super.key});

  @override
  State<ChatExample> createState() => _ChatExampleState();
}

class _ChatExampleState extends State<ChatExample> {
  TextEditingController controller = TextEditingController();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return m.Scaffold(
      appBar: AppBar(title: Text("Neuer Chat")),
      body: Center(
        child: SizedBox(
          width: 200,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (value) {
              context.bit<ExampleBit>().addContact(value);
            },
          ),
        ),
      ),
    );
  }
}
