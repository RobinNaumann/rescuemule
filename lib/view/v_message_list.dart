import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_received.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
      create: (_) => MsgsBit(),
      child: MsgsBit.builder(
        onData:
            (bit, data) => Column(
              children:
                  [
                    for (var message in data)
                      Card(
                        scheme: ColorSchemes.secondary,
                        child: Text(message),
                      ),
                  ].spaced(),
            ),
      ),
    );
  }
}
