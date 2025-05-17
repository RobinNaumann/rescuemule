import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/bit/bit/bit_control.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/service/s_bluetooth.dart';

class _Data {
  final List<String> messages;
  final List<Peripheral> devices;

  _Data(this.messages, this.devices);
}

class MessagingBit extends MapMsgBitControl<_Data> {
  StreamSubscription? _visibles;
  static const builder = MapMsgBitBuilder<_Data, MessagingBit>.make;

  MessagingBit() : super.worker((_) async => _Data([], [])) {
    if (!BluetoothService.isInitialized) {
      BluetoothService.init(
        appId: appName,
        services: [1],
        advertising: [
          BLEService(
            id: 1,
            variables: [
              BLEVariable(
                id: 1,
                onWrite: (_, bytes) {
                  var d = state.whenOrNull(onData: (d) => d);
                  var msg = String.fromCharCodes(bytes);
                  emit(_Data([...d?.messages ?? [], msg], d?.devices ?? []));
                },
              ),
            ],
          ),
        ],
      );
      _visibles = BluetoothService.i.devices.listen((devices) {
        var d = state.whenOrNull(onData: (d) => d);
        emit(_Data(d?.messages ?? [], devices));
      });
    }
  }

  @override
  void dispose() {
    _visibles?.cancel();
    super.dispose();
  }
}
