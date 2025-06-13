import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_network.dart';
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

    child: NetworksBit.builder(
      onData:
          (_, networks) => Padded.all(
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  [
                    DeviceInfoView(),
                    Text.h5("available devices"),
                    DevicesList(networksService: networks),
                    Text.h5("send message"),
                    SendView(networksService: networks),
                    Text.h5("received messages"),
                    MessageList(networksService: networks),
                  ].spaced(),
            ),
          ),
    ),
  );
}
