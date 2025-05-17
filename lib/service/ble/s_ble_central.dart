import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/services/s_app_info.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

final DEMO_central_service = BleCentralManager();

class BleCentralManager {
  final _manager = CentralManager();

  Future<void> _prepare() async {
    if (runPlatform.isAndroid) _manager.authorize();
  }

  Future<int> writeToService(
    int service,
    int variable,
    List<int> message,
  ) async {
    // find the devices
    final devices = await scan([service]);
    var sentTo = 0;

    for (var device in devices) {
      // send the message
      try {
        await _send(service, variable, device, message);
        sentTo++;
      } catch (e) {
        print("Failed to send to $device");
      }
    }
    return sentTo;
  }

  Future<void> _send(
    int service,
    int char,
    Peripheral peripheral,
    List<int> message,
  ) async {
    await _prepare();

    final sUUID = makeUUID(service);
    final cUUID = makeUUID(service, char);

    await _manager.connect(peripheral);
    var gatt = await _manager.discoverGATT(peripheral);

    try {
      await _manager.writeCharacteristic(
        peripheral,
        gatt
            .firstWhere((s) => s.uuid == sUUID)
            .characteristics
            .firstWhere((c) => c.uuid == cUUID),
        value: Uint8List.fromList(message),
        type: GATTCharacteristicWriteType.withoutResponse,
      );
    } catch (e, t) {
      print("Failed to send to $peripheral");
      print(e);
      print(t);
      rethrow;
    }
    _manager.disconnect(peripheral);
  }

  Future<List<Peripheral>> scan(List<int> services) async {
    await _prepare();

    final controller = StreamController<DiscoveredEventArgs>();

    _manager.startDiscovery(
      serviceUUIDs: services.map((e) => makeUUID(e)).toList(),
    );

    //TODO: possible memory leak
    _manager.discovered.listen((event) {
      if (controller.isClosed) return;
      controller.add(event);
    });

    Future.delayed(const Duration(seconds: 4)).then((_) {
      _manager.stopDiscovery();
      controller.close();
    });

    return (await controller.stream.toList())
        .map((e) => e.peripheral)
        .toSet()
        .toList();
  }
}
