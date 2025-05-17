import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/s_bluetooth.dart';

class SendView extends StatelessWidget {
  const SendView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Row(
      children:
          [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: elbeFieldDeco(context, hint: "enter message"),
              ),
            ),
            IconButton.major(
              icon: Icons.send,
              onTap: () async {
                var to = await BluetoothService.i.write(
                  service: 1,
                  variable: 1,
                  message: controller.value.text.codeUnits,
                );
                controller.clear();
                context.showToast(
                  "sent to ${to.length} devices",
                  icon: Icons.check,
                );
              },
            ),
          ].spaced(),
    );
  }
}

List<int> stringToAscii(String input) {
  return input.codeUnits.map((unit) => unit <= 127 ? unit : 63).toList();
}
