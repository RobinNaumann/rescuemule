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
                context.showToast("discovering and sending...");
                var to = await BluetoothService.i.write(
                  1,
                  1,
                  controller.value.text.codeUnits,
                );
                controller.clear();
                context.showToast("message sent to $to");
              },
            ),
          ].spaced(),
    );
  }
}

List<int> stringToAscii(String input) {
  return input.codeUnits.map((unit) => unit <= 127 ? unit : 63).toList();
}
