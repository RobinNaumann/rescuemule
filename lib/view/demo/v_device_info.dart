import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';

class DeviceInfoView extends StatelessWidget {
  const DeviceInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      scheme: ColorSchemes.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text.code("deviceId: ${debugDeviceId}")],
      ),
    );
  }
}
