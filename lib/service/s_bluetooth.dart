import 'dart:async';

import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/service/ble/s_ble_central.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BluetoothService {
  static BluetoothService? _i;
  static BluetoothService get i => _i!;

  final String appId;
  late final BLEPeripheralManager _pMan;
  late final BleCentralManager _cMan;
  final StreamController<List<int>> messageStream =
      StreamController.broadcast();
  BluetoothService._(this.appId) {
    _pMan = BLEPeripheralManager(appId);
    _cMan = BleCentralManager();
  }

  static Future<void> init(String appId) async {
    if (_i != null) throw Exception("Service already initialized");
    _i = BluetoothService._(appId);
  }

  Future<int> write(int service, int variable, List<int> message) async {
    return await _cMan.writeToService(service, variable, message);
  }

  Future<void> advertise() async {
    final BLEService service = BLEService(
      id: 1,
      variables: [
        BLEVariable(
          id: 1,
          onWrite: (v) async {
            print("Received: $v");
            messageStream.add(v);
          },
          onRead: () async => [0x00, 0xff],
        ),
      ],
    );

    await _pMan.advertise([service]);
  }
}
