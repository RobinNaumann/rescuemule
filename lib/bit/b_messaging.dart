import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/bit/bit/bit_control.dart';
import 'package:flutter/services.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/service/s_message.dart';

class _Msg {
  final Message message;
  final UUID device;

  _Msg(this.message, this.device);
}

class _Data {
  final List<_Msg> messages;
  final List<String> devices;

  _Data(this.messages, this.devices);
}

class MessagingBit extends MapMsgBitControl<_Data> {
  StreamSubscription? _visibles;
  static const builder = MapMsgBitBuilder<_Data, MessagingBit>.make;

  MessagingBit() : super.worker((_) async => _Data([], [])) {
    _init();
  }

  void _init() async {
    if (!BluetoothService.isInitialized) {
      await Future.delayed(Duration(seconds: 2));
      BluetoothService.init(
        appId: appName,
        services: [1],
        advertising: [
          BLEService(
            id: 1,
            variables: [
              BLEVariable(
                id: 1,
                onWrite: (from, bytes) {
                  var d = state.whenOrNull(onData: (d) => d);
                  final message = Message.fromPacket(
                    Uint8List.fromList(bytes),
                  ).withHop(Hop.ble(from.toString()));
                  emit(
                    _Data([
                      ...d?.messages ?? [],
                      _Msg(message, from),
                    ], d?.devices ?? []),
                  );
                  AudioPlayer().play(AssetSource("sounds/esel_pixabay.mp3"));
                },
              ),
            ],
          ),
        ],
      );
      _visibles = BluetoothService.i.devices.listen((devices) {
        var d = state.whenOrNull(onData: (d) => d);
        emit(_Data(d?.messages ?? [], devices));

        MessageService.i.onDeviceDiscovery(devices, (dev, messages) async {
          return await BluetoothService.i.send(
            device: dev,
            service: 1,
            variable: 1,
            messages: messages,
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _visibles?.cancel();
    super.dispose();
  }
}
