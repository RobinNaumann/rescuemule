import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/view/v_message_list.dart';
import 'package:rescuemule/view/v_send.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    title: appName,

    child: Padded.all(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children:
            [
              Button.minor(
                label: "scan",
                onTap: () async {
                  context.showToast("TODO: discover");
                  MessageService service = MessageService();

                  service.clearMessages();

                  Message m1 = Message.createMessage(
                    sender: "jannes",
                    receiver: "ich",
                    message: "message",
                  );
                  Message m2 = Message.createMessage(
                    sender: "ich",
                    receiver: "jannes",
                    message: "message",
                  );

                  service.saveMessage(m1);
                  service.saveMessage(m2);

                  service.loadMessages().then((result) {
                    result.forEach((e) {
                      print(e.toJson());
                    });
                  });
                },
              ),
              Mule(name: "Jonas"),
              Text.h5("send a message"),
              SendView(),
              Text.h5("received messages"),
              MessageList(),
            ].spaced(),
      ),
    ),
  );
}

class Mule extends StatelessWidget {
  final String name;
  const Mule({super.key, this.name = "Unknown Mule"});

  @override
  Widget build(BuildContext context) {
    return Text("Hello I'm the mule $name");
  }
}
