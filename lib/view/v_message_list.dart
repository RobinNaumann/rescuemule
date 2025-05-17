import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_messaging.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagingBit.builder(
      onData:
          (bit, data) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                [
                  for (var message in data.messages)
                    Card(scheme: ColorSchemes.secondary, child: Text(message)),
                ].spaced(),
          ),
    );
  }
}
