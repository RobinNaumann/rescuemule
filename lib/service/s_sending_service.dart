//when discovering check if any messages need to be send
import 'dart:collection';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_sent_ids_service.dart';

class SendingService {
  final MessageService _messageService = MessageService();

  Future<void> registerListener() async {
    BluetoothService.i.devices.listen((devices) {
      // This will be called whenever the list of devices changes
      //print('Devices: $devices');
      check(devices);
    });
  }

  Future<void> check(List<Peripheral> devices) async {
    SentIDsService sentIDsService = SentIDsService();
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
        for (var message in messages) {
          // send message
          BluetoothService.i.write(
            service: 1,
            variable: 1, //todo actual values
            message: message.toString().codeUnits,
            devices: [device.uuid],
          );
          sentIDsService.addSentID(
            device.uuid,
            message.id,
          ); //acknowledge that messsage was sent
          logger.d(
            this,
            'Sending message: ${message.id} to device: ${device.uuid}',
          );
        }
      } else {
        logger.d(this, 'No messages to send to device: ${device.uuid}');
      }
    }
  }
}
