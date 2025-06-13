import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';

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
      final t = controller.value.text;

      final m = Message.create(
        type: "text",
        sender: "unknown",
        receiver: "DEMO_USER",
        message: t == "" ? "NO TEXT" : t,
      );

      networksService.send(m);
      controller.clear();
    } catch (e) {
      // ignore: use_build_context_synchronously
      context.showToast("failed to send message", icon: Icons.alertOctagon);
      logger.w(this, e.toString());
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
