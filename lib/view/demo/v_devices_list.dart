import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/service/connectivity/s_connections.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: networksService.devices,
      builder:
          (_, data) =>
              data.data == null || data.data!.isEmpty
                  ? Text("no devices found", textAlign: TextAlign.center)
                  : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                            for (var d in data.data ?? <NetworkDevice>[])
                              Card(
                                scheme: ColorSchemes.secondary,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text(d.network), Text.bodyS(d.id)],
                                ),
                              ),
                          ].spaced(),
                    ),
                  ),

      /*Column(
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
          ),*/
    );
  }
}
