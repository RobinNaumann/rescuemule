import 'package:elbe/elbe.dart' as a;
import 'package:flutter/material.dart';
import 'package:rescuemule/bit/b_example.dart';
import 'package:rescuemule/service/s_user_service.dart';

import 'chat.dart';

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
    return ScaffoldExample();
  }
}

class ScaffoldExample extends StatefulWidget {
  const ScaffoldExample({super.key});

  @override
  State<ScaffoldExample> createState() => _ScaffoldExampleState();
}

class _ScaffoldExampleState extends State<ScaffoldExample> {
  final UserService userService = UserService();
  int currentPageIndex = 0;
  TextEditingController controller = TextEditingController();
  

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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.message_rounded),
            tooltip: 'messages',
            onPressed: () {
              context.push("/msg");
            },
          ),
        ],
      ),
      body:
          <Widget>[
            ExampleBit.builder(onData: (bit, data) => 
            /// Home page
           Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image
                    Image.asset(
                        'assets/images/background.png',
                        fit: BoxFit.cover,
                      
                    ),
                    // Foreground widgets
                    Positioned(
                      top: 8,
                      left: 8,
                      child: SizedBox(
                        width: 200,
                        child: a.Column(
                          children: [
                            Text("current name: ${data.user ?? "--"}"),
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onSubmitted: (value) => bit.setUsername(value)
                            ),
                          ].spaced(),
                        ),
                      ),
                    ),
                    // Add more widgets here if needed
                  ],
                
              
            ),
            ),

            /// Chats page
            ExampleBit.builder(onData: (bit, data) =>
            ListView(
              children: [
                for(String contact in data.contacts)
              Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.message_sharp),
                    title: Text(contact),
                    subtitle: Text("Peter ist cool"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(myChat: MyChat(contact: contact)),
                        ),
                      );
                    },
                  ),
                )
              ]
            ),
            )
          ][currentPageIndex],
    

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home hello'),
          NavigationDestination(icon: Icon(Icons.menu), label: 'Chats'),
        ],
        backgroundColor: primary,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatExampleApp()
            ),
          );
          setState(() {});
        },
        foregroundColor: primary,
        backgroundColor: secondary,
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
