import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_device_id.dart';

class DeviceInfoView extends StatelessWidget {
  const DeviceInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppConfigBit.builder(
      onData: (bit, config) {
        final idCtrl = TextEditingController(text: config.deviceId);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: idCtrl,
              onSubmitted: (v) {
                bit.set(config.copyWith(deviceId: v));
                idCtrl.clear();
                context.showToast("Device ID updated to: $v");
              },
              decoration: elbeFieldDeco(
                context,
                hint: "Device ID",
                label: "Device ID",
              ),
            ),
          ],
        );
      },
    );
  }
}
