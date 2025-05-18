import 'package:elbe/elbe.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_user_service.dart';

class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  TextEditingController controller = TextEditingController();
  bool isSending = false;

  void send() async {
    if (isSending) return;
    try {
      context.showToast("trying to send...", icon: Icons.send);
      messageService.saveMessage(
        Message(
          sender: await UserService().loadUser() ?? "unknown",
          receiver: "DEMO_USER",
          message: controller.value.text,
          creationTime: DateTime.now(),
        ),
      );
      controller.clear();

      /*setState(() => isSending = true);
      var to = await BluetoothService.i.write(
        service: 1,
        variable: 1,
        message: stringToAscii(controller.value.text),
      );
      if (to.isEmpty) {
        // ignore: use_build_context_synchronously
        context.showToast("no devices found", icon: Icons.alertTriangle);
        setState(() => isSending = false);
        return;
      }
      controller.clear();
      // ignore: use_build_context_synchronously
      context.showToast("sent to ${to.length} devices", icon: Icons.check);
      setState(() => isSending = false);*/
    } catch (e) {
      // ignore: use_build_context_synchronously
      context.showToast("failed to send message", icon: Icons.alertOctagon);
      setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: elbeFieldDeco(context, hint: "enter message"),
              ),
            ),
            SizedBox(
              width: context.rem(3.5),
              child: Button.major(
                icon: Icons.send,
                onTap: isSending ? null : () => send(),
              ),
            ),
          ].spaced(),
    );
  }
}

List<int> stringToAscii(String input) {
  return input.codeUnits.map((unit) => unit <= 127 ? unit : 63).toList();
}
