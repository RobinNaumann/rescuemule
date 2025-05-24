import 'package:rescuemule/model/m_message.dart';

class MessageService {
  static final MessageService i = MessageService._();

  MessageService._();
  final List<Message> _messagePool = [];

  // Method to send a message
  void sendMessage(Message message) {
    // Add the message to the pool
    _messagePool.add(message);
  }

  Future<void> onDeviceDiscovery(
    List<DeviceId> devices,
    Future<List<String>> Function(DeviceId device, List<Message> message)
    sendMessages,
  ) async {
    //TODO: demo flooding mode
    for (var device in devices) {
      if (_messagePool.isEmpty) return;

      final result = await sendMessages(device, _messagePool);
      _messagePool.removeWhere((m) => result.contains(m.id));
    }
  }
}
