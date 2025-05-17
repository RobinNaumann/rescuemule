import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_messaging.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagingBit.builder(
      onData:
          (bit, data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                [
                  if (data.devices.isEmpty)
                    Text("no devices found", textAlign: TextAlign.center),
                  for (var d in data.devices)
                    Card(
                      scheme: ColorSchemes.secondary,
                      child: Text(d.uuid.toString()),
                    ),
                ].spaced(),
          ),
    );
  }
}
