import 'package:flutter/material.dart';
import 'package:rescuemule/main.dart';
import 'chat.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

const Color primary = Color(0xFF46B4E3);
const Color secondary = Color(0xFF212E62);
const Color warning = Color(0xFFFF1D1D);
const Color grey = Color(0xFFB2B2B2);
const Color selected = Color.fromARGB(80, 255, 255, 255);


/// Flutter code sample for [Scaffold].

void main() => runApp(const ScaffoldExampleApp());

class ScaffoldExampleApp extends StatelessWidget {
  const ScaffoldExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ScaffoldExample());
  }
}

class ScaffoldExample extends StatefulWidget {
  const ScaffoldExample({super.key});

  @override
  State<ScaffoldExample> createState() => _ScaffoldExampleState();
}

class _ScaffoldExampleState extends State<ScaffoldExample> {
  int currentPageIndex = 0;
  final List<MyChat> chats = [
  MyChat(contact: 'Peter'),
  MyChat(contact: 'Peter2'),
  // Add more chats here
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RescueMule'), 
        backgroundColor: primary, 
        shadowColor: grey, 
        elevation: 3.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {}
          ), ], 
      ),
      body: <Widget>[
            /// Home page
            Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Center(child: Text('Home page')),
              ),
            ),

            /// Chats page
            ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.message_sharp),
                    title: Text(chat.contact),
                    subtitle: Text("Peter ist cool"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(myChat: chat),
                        ),
                      );
                    },
                  )
                );
              }
            )] [currentPageIndex],


            ///const Padding(
            ///  padding: EdgeInsets.all(8.0),
            ///  child: Column(
            ///    children: <Widget>[
            ///      Card(
            ///        child: ListTile(
            ///          leading: Icon(Icons.message_sharp),
            ///          title: Text('Freund 1'),
            ///          subtitle: Text('This is a notification'),
            ///        ),
            ///      ),
            ///      Card(
            ///        child: ListTile(
            ///          leading: Icon(Icons.message_sharp),
            ///          title: Text('Freund 2'),
            ///          subtitle: Text('This is a notification'),
            ///        ),
            ///      ),
            ///    ],
            ///  ),
            ///)] [currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu), label: 'Chats'),
        ],
        backgroundColor: primary
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        foregroundColor: primary,
        backgroundColor: secondary,
        shape: CircleBorder(),
        child: const Icon(Icons.add)
      )
    );
  }
}

class ChatDetailPage extends StatelessWidget {
  final MyChat myChat;
  ChatDetailPage({super.key, required this.myChat});


  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text(myChat.contact)),
      body: Center(child: myChat),
    );
  }
}