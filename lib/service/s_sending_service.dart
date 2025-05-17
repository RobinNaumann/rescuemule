//when discovering check if any messages need to be send
import 'dart:collection';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/ble/s_ble_central.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_sent_ids_service.dart';

class SendingService {
  final MessageService _messageService = MessageService();

  Future<void> check() async {
    BluetoothService _bluetoothService = BluetoothService.i;
    SentIDsService _sentIDsService = SentIDsService();
    // Example: Load messages and print how many are pending to send
    final devices = await DEMO_central_service.scan([1]);
    HashMap<Peripheral, List<Message>> deviceMessageMap = HashMap();

    for (var device in devices) {
      _messageService.getMessagesToSend(device.uuid).then((messages) {
        deviceMessageMap[device] = messages;
      });
    }

    for (var entry in deviceMessageMap.entries) {
      final device = entry.key;
      final messages = entry.value;

      if (messages.isNotEmpty) {
        // Send messages to the device
        for (var message in messages) {
          // send message
          _bluetoothService.write(
            1,
            1,
            message.toString().codeUnits,
          );
          _sentIDsService.addSentID(device.uuid, message.id);//acknowledge that messsage was sent
          print('Sending message: ${message.id} to device: ${device.uuid}');
        }
      } else {
        print('No messages to send to device: ${device.uuid}');
      }
    }
  }
}