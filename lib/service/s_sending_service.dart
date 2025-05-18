//when discovering check if any messages need to be send
import 'dart:collection';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/service/s_message_service.dart';
import 'package:rescuemule/service/s_sent_ids_service.dart';
import 'package:rescuemule/view/v_message_list.dart';

final sendingService = SendingService();
class SendingService {
  Future<void> registerListener() async {
    BluetoothService.i.devices.listen((devices) {
      check(devices);
    });
  }

  Future<void> check(List<Peripheral> devices) async {
    await messageService.removeExpiredMessages();
    HashMap<Peripheral, List<Message>> deviceMessageMap = HashMap();

    for (var device in devices) {
      final msgs = await messageService.getMessagesToSend(formatMacFromUUID(device.uuid));
      deviceMessageMap[device] = msgs;

      for (var message in msgs) {
        logger.d(
          this,
          'Message: ${message.id} to device: ${formatMacFromUUID(device.uuid)} needs to be sent',
        );
      }
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
            message: message.toBytes(),
            devices: [device.uuid],
          );
          sentIDsService.addSentID(
            formatMacFromUUID( device.uuid ),
            message.id,
          ); //acknowledge that messsage was sent
          logger.d(
            this,
            'Sending message: ${message.id} to device: ${formatMacFromUUID(device.uuid)}',
          );
        }
      } else {
        logger.d(this, 'No messages to send to device: ${formatMacFromUUID(device.uuid)}');
      }
    }
  }
}
