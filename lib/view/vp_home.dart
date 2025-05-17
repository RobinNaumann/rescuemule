import 'package:elbe/elbe.dart' as a;
import 'package:flutter/material.dart';
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
    return const MaterialApp(home: ScaffoldExample());
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
  final List<MyChat> chats = [
  MyChat(contact: 'Peter'),
  MyChat(contact: 'Peter2'),
  // Add more chats here
];
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    userService.loadUser().then((onValue){
      controller.text = onValue ?? "Name";});
    super.initState();
  }

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
            /// Home page
            Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (value) => userService.saveUser(value),
                        ),
                      ),
                    ),
                    // Zentrierter Text
                    const Center(child: Text('Home page')),
                  ],
                ),
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
                  ),
                );
              },
            ),
          ][currentPageIndex],

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
        backgroundColor: primary,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: primary,
        backgroundColor: secondary,
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
