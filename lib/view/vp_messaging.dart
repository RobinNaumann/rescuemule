import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_messaging.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/view/v_devices_list.dart';
import 'package:rescuemule/view/v_message_list.dart';
import 'package:rescuemule/view/v_send.dart';

class MessagingView extends StatelessWidget {
  const MessagingView({super.key});

  @override
  Widget build(BuildContext context) => BitProvider(
    create: (_) => MessagingBit(),
    child: Scaffold(
      title: appName,

      child: Padded.all(
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              [
                Text.h5("send a message"),
                SendView(),
                Text.h5("discovered devices"),
                DevicesList(),
                Text.h5("received messages"),
                MessageList(),
              ].spaced(),
        ),
      ),
    ),
  );
}
