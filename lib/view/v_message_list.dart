import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_messaging.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagingBit.builder(
      onData:
          (bit, data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                [
                  for (var m in data.messages)
                    Card(
                      scheme: ColorSchemes.secondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [Text(m.message.toString())],
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
