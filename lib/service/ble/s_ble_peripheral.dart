import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/services/s_app_info.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/service/ble/chunker.dart';

class BLEPeripheralManager {
  final String appId;
  final _manager = PeripheralManager();

  BLEPeripheralManager(this.appId);

  Future<void> prepare() async {
    //request the permission
    if (!runPlatform.isMacos) {
      final granted = await _manager.authorize();
      if (!granted) {
        throw Exception("Permission not granted");
      }
    }
  }

  Future<void> advertise(List<BLEService> services) async {
    final chunker = Chunker(services);
    await prepare();
    final ganttS = services.map((s) => s.asGATT()).toList();

    for (var service in ganttS) {
      try {
        await _manager.addService(service);
      } catch (e) {
        logger.w(this, "Failed to add service ${service.uuid}", e);
      }
    }

    _manager.characteristicReadRequested.listen((state) async {
      final uuid = state.characteristic.uuid;
      final central = state.central.uuid;
      try {
        final char = findCharacteristicByUUID(services, uuid);
        final v = await char.onRead!.call(central);
        _manager.respondReadRequestWithValue(
          state.request,
          value: Uint8List.fromList(v),
        );
      } catch (e) {
        logger.w(this, "Failed to read characteristic $uuid from $central", e);
        _manager.respondReadRequestWithError(
          state.request,
          error: GATTError.unlikelyError,
        );
      }
    });

    _manager.characteristicWriteRequested.listen((state) async {
      final char_ = state.characteristic.uuid;
      final origin = state.central.uuid;
      final message = state.request.value;
      try {
        chunker.onReceive(origin, char_, message);
        _manager.respondWriteRequest(state.request);
      } catch (e) {
        logger.w(this, "Failed to write characteristic $char_ from $origin", e);
        _manager.respondWriteRequestWithError(
          state.request,
          error: GATTError.unlikelyError,
        );
      }
    });

    await _manager.startAdvertising(
      Advertisement(
        name: "${appId}_$debugName",
        serviceUUIDs: ganttS.map((s) => s.uuid).toList(),
      ),
    );
  }

  Future<void> stopAdvertising() async {
    await _manager.stopAdvertising();
  }
}

UUID makeUUID(int service, [int? char]) {
  if (service > 0xFFFF) throw Exception("ID must fit 4 bytes");
  if (char != null && char > 0xFFF) throw Exception("char must fit 3 bytes");

  const base = "4a5b-a4c0-f7f5a6c278e2";
  final appHex = appName.hashCode
      .toRadixString(16)
      .padLeft(4, '0')
      .substring(0, 4);
  final sHex = service.toRadixString(16).padLeft(4, "0");
  final cHex = char?.toRadixString(16).padLeft(4, "0") ?? "AAAA";
  return UUID.fromString("$appHex$sHex-$cHex-$base".toLowerCase());
}
