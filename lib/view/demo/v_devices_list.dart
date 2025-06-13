import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/connectivity/s_connections.dart';
import 'package:rescuemule/service/s_networks.dart';

class DevicesList extends StatelessWidget {
  final NetworksService networksService;
  const DevicesList({super.key, required this.networksService});

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
                                padding: RemInsets.symmetric(
                                  horizontal: .75,
                                  vertical: .5,
                                ),
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
