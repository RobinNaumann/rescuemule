import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/view/demo/v_device_info.dart';
import 'package:rescuemule/view/demo/v_devices_list.dart';
import 'package:rescuemule/view/demo/v_message_list.dart';
import 'package:rescuemule/view/demo/v_send.dart';

class MessagingView extends StatelessWidget {
  const MessagingView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    title: appName + " Demo",

    child: Padded.all(
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children:
            [
              DeviceInfoView(),
              Text.h5("available devices"),
              DevicesList(),
              Text.h5("send message"),
              SendView(),

              Text.h5("received messages"),
              MessageList(),
            ].spaced(),
      ),
    ),
  );
}
