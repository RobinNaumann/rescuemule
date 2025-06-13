import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/elbe.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_networks.dart';

final List<Message> _demoAllReceived = [];

class MessageList extends StatelessWidget {
  final NetworksService networksService;
  MessageList({super.key, required this.networksService});

  /// A stream of all messages received by the current device.
  late Stream<List<Message>> demoAllReceived =
      networksService.received.map((m) {
        _demoAllReceived.add(m);
        return _demoAllReceived;
      }).asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: demoAllReceived,
      builder:
          (_, data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                [
                  for (var m in data.data ?? <Message>[])
                    Card(
                      scheme: ColorSchemes.secondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [Text(m.toString())],
                      ),
                    ),
                ].spaced(),
          ),
    );
  }
}

String formatMacFromUUID(UUID uuid) {
  final macValues = uuid.toString().split("-").last;

  //group into pairs of 2
  final macPairs = [];
  for (var i = 0; i < macValues.length; i += 2) {
    macPairs.add(macValues.substring(i, i + 2));
  }
  return macPairs.join(":");
}
