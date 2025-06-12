import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/service/networks/ble/chunker.dart';
import 'package:rescuemule/service/networks/ble/s_ble_peripheral.dart';

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

  Future<List<int>> write(
    UUID device,
    int service,
    int variable,
    List<List<int>> messages,
  ) async {
    // find the devices
    Peripheral? per = _visibles.firstWhereOrNull((d) => d.uuid == device);

    if (per == null) {
      logger.v(this, "No device found for $device");
      return [];
    }

    final List<int> sentTo = [];

    for (int i = 0; i < messages.length; i++) {
      try {
        await _send(per, service, variable, messages[i]);
        sentTo.add(i);
      } catch (e) {
        logger.w(this, "Failed to send to $device", e);
      }
    }
    return sentTo;
  }

  Future<void> _send(
    Peripheral peripheral,
    int service,
    int char,
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

    await Chunker.sendChunks(message, (chunk) async {
      await _manager.writeCharacteristic(
        peripheral,
        gattChar,
        value: Uint8List.fromList(chunk),
        type: GATTCharacteristicWriteType.withResponse,
      );
    });
    //await Future.delayed(const Duration(milliseconds: 10));
    await _manager.disconnect(peripheral);
  }

  Future<void> _scanContinously() async {
    check() async {
      final devices = await _scan(services);
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
