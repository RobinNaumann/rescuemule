import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/ble/s_ble_central.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BluetoothService {
  static BluetoothService? _i;
  static bool get isInitialized => _i != null;
  static BluetoothService get i => _i!;

  final String appId;
  final List<int> services;
  final List<BLEService> advertising;

  late final BLEPeripheralManager _pMan;
  late final BleCentralManager _cMan;
  Stream<List<String>> get devices => _cMan.visiblesStream.map(
    (ds) => ds.map((d) => d.uuid.toString()).toList(),
  );
  BluetoothService.init({
    required this.appId,
    required this.services,
    required this.advertising,
  }) {
    if (_i != null) throw Exception("Service already initialized");
    _pMan = BLEPeripheralManager(appId);
    _cMan = BleCentralManager(services: services);
    _i = this;
    _advertise();
  }

  Future<List<String>> send({
    required String device,
    required int service,
    required int variable,
    required List<Message> messages,
  }) async {
    final res = await _cMan.write(
      UUID.fromString(device),
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
    _i = null;
  }
}
