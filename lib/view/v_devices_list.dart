import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';

class DevicesList extends StatelessWidget {
  const DevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: topologyService.devices,
      builder:
          (_, data) => Text(
            data.error != null
                ? "error"
                : "${data.data?.length ?? "-"} device${data.data?.length == 1 ? "" : "s"} visible",
            textAlign: TextAlign.center,
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
