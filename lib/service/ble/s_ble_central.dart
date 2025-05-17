import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BleCentralManager {
  List<int> services = [];
  Timer? _checker;
  List<Peripheral> _visibles = [];
  final StreamController<List<Peripheral>> _visiblesNotify =
      StreamController<List<Peripheral>>.broadcast();
  Stream<List<Peripheral>> get visiblesStream => _visiblesNotify.stream;

  final _manager = CentralManager();

  BleCentralManager({required this.services}) {
    _prepare();
    _scanContinously();
  }

  void _prepare() {
    if (runPlatform.isAndroid) _manager.authorize();
  }

  Future<List<UUID>> write(int service, int variable, List<int> message) async {
    // find the devices
    List<UUID> sentTo = [];

    for (var device in _visibles) {
      try {
        await _send(service, variable, device, message);
        sentTo.add(device.uuid);
      } catch (e) {
        print("Failed to send to $device");
        print(e);
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
    final sUUID = makeUUID(service);
    final cUUID = makeUUID(service, char);

    await _manager.connect(peripheral);

    var gatt = await _manager.discoverGATT(peripheral);
    var gattChar = gatt
        .firstWhereOrNull((s) => s.uuid == sUUID)
        ?.characteristics
        .firstWhereOrNull((c) => c.uuid == cUUID);

    if (gattChar == null) {
      throw Exception("Characteristic $service-$char not found");
    }

    await _manager.writeCharacteristic(
      peripheral,
      gattChar,
      value: Uint8List.fromList(message),
      type: GATTCharacteristicWriteType.withResponse,
    );

    //await Future.delayed(const Duration(milliseconds: 10));
    _manager.disconnect(peripheral);
  }

  Future<void> _scanContinously() async {
    check() async {
      final devices = await _scan(services);
      print("Found ${devices.length} devices");
      _visibles = devices;
      _visiblesNotify.add(devices);
    }

    Timer.periodic(Duration(seconds: 5), (_) => check());
    check();
  }

  Future<List<Peripheral>> _scan(List<int> services) async {
    final controller = StreamController<DiscoveredEventArgs>();

    _manager.startDiscovery(
      serviceUUIDs: services.map((e) => makeUUID(e)).toList(),
    );

    var listener = _manager.discovered.listen((event) {
      if (controller.isClosed) return;
      controller.add(event);
    });

    Future.delayed(const Duration(seconds: 3)).then((_) {
      _manager.stopDiscovery();
      controller.close();
      listener.cancel();
    });

    return (await controller.stream.toList())
        .map((e) => e.peripheral)
        .toSet()
        .toList();
  }

  void dispose() {
    _checker?.cancel();
  }
}
