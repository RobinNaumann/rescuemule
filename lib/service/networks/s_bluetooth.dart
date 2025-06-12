import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/services.dart';
import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/networks/ble/s_ble_central.dart';
import 'package:rescuemule/service/networks/ble/s_ble_peripheral.dart';

typedef SendFn =
    Future<List<String>> Function(String device, List<Message> messages);

abstract class NetworkService {
  String get key;
  Stream<List<String>> get devices;
  Stream<Message> get messages;
  Future<List<String>> send(String device, List<Message> messages);
  void dispose();
}

class BluetoothService extends NetworkService {
  @override
  get key => "bluetooth";

  final String appId;
  late final List<int> services;
  late final List<BLEService> advertising;
  final StreamController<Message> _messageCtrl = StreamController.broadcast();
  @override
  get messages => _messageCtrl.stream;

  late final BLEPeripheralManager _pMan;
  late final BleCentralManager _cMan;
  @override
  Stream<List<String>> get devices => _cMan.visiblesStream.map(
    (ds) => ds.map((d) => d.uuid.toString()).toList(),
  );

  BluetoothService.preset({required this.appId}) {
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
        ],
      ),
    ];

    _start();
  }

  BluetoothService({
    required this.appId,
    required this.services,
    required this.advertising,
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
  }
}
