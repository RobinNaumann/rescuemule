import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/services.dart';
import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/connectivity/s_network.dart';
import 'package:rescuemule/service/networks/bluetooth/ble/s_ble_central.dart';
import 'package:rescuemule/service/networks/bluetooth/ble/s_ble_peripheral.dart';

typedef SendFn =
    Future<List<String>> Function(String device, List<Message> messages);

class BluetoothManager extends NetworkManager {
  @override
  get key => "bluetooth";

  final String deviceId;
  final String appId;
  late final List<int> services;
  late final List<BLEService> advertising;
  final StreamController<Message> _messageCtrl = StreamController.broadcast();
  @override
  get messages => _messageCtrl.stream;

  late final BLEPeripheralManager _pMan;
  late final BleCentralManager _cMan;
  @override
  Stream<List<String>> get hardwareDevices =>
      _cMan.visiblesStream.asyncMap((ds) async {
        return ds.map((d) => d.uuid.toString()).toList();
      });

  BluetoothManager.preset({required this.appId, required this.deviceId}) {
    services = [1];
    advertising = [
      BLEService(
        id: 1,
        variables: [
          BLEVariable(
            id: 1,
            onWrite: (from, bytes) {
              final m = Message.fromPacket(
                Uint8List.fromList(bytes),
              ).withHop(Hop.ble(from.toString()));
              _messageCtrl.add(m);
            },
          ),
          BLEVariable(id: 2, onRead: (from) async => deviceId.codeUnits),
        ],
      ),
    ];

    _start();
  }

  BluetoothManager({
    required this.appId,
    required this.services,
    required this.advertising,
    required this.deviceId,
  }) {
    _start();
  }

  void _start() {
    _pMan = BLEPeripheralManager(appId);
    _cMan = BleCentralManager(services: services);
    _advertise();
  }

  @override
  Future<List<String>> send(
    String device,

    List<Message> messages, {
    int service = 1,
    int variable = 1,
  }) async {
    final hardwareId = hardwareMappings[device];
    if (hardwareId == null) {
      throw Exception("Device $device not found in hardware mappings");
    }

    final res = await _cMan.write(
      UUID.fromString(hardwareId),
      service,
      variable,
      messages.map((m) => m.asPacket()).toList(),
    );

    return res.map((e) => messages[e].id).toList();
  }

  Future<void> _advertise() async {
    await Future.delayed(const Duration(seconds: 2));
    await _pMan.advertise(advertising);
  }

  void dispose() {
    _cMan.dispose();
  }

  @override
  getDeviceId(hardwareId) async {
    final bits = await _cMan.read(UUID.fromString(hardwareId), 1, 2);
    return String.fromCharCodes(bits);
  }
}
