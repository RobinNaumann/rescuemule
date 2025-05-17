import 'dart:typed_data';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:elbe/services/s_app_info.dart';
import 'package:rescuemule/model/m_ble_service.dart';

class BLEPeripheralService {
  final String appId;
  final _manager = PeripheralManager();

  BLEPeripheralService(this.appId);

  Future<void> prepare() async {
    //request the permission
    if (!runPlatform.isMacos) {
      final granted = await _manager.authorize();
      if (!granted) {
        throw Exception("Permission not granted");
      }
    }
  }

  UUID uuid(int service, [int? char]) {
    if (service > 0xFFFF) throw Exception("ID must fit 4 bytes");
    if (char != null && char > 0xFFF) throw Exception("char must fit 3 bytes");

    const base = "4a5b-a4c0-f7f5a6c278e2";
    final appHex = appId.hashCode
        .toRadixString(16)
        .padLeft(4, '0')
        .substring(0, 4);
    final sHex = service.toRadixString(16).padLeft(4);
    final cHex = char?.toRadixString(16).padLeft(4) ?? "AAAA";
    return UUID.fromString("$appHex$sHex-$cHex-$base");
  }

  Future<void> advertise(List<BLEService> services) async {
    await prepare();
    final ganttS = services.map((s) => s.asGATT(this)).toList();

    for (var service in ganttS) {
      await _manager.addService(service);
    }

    _manager.characteristicReadRequested.listen((state) async {
      final uuid = state.characteristic.uuid;
      try {
        final char = _findCharacteristic(services, uuid);
        final v = await char.onRead!.call();
        _manager.respondReadRequestWithValue(
          state.request,
          value: Uint8List.fromList(v),
        );
      } catch (e) {
        _manager.respondReadRequestWithError(
          state.request,
          error: GATTError.unlikelyError,
        );
      }
    });

    _manager.characteristicWriteRequested.listen((state) async {
      final uuid = state.characteristic.uuid;
      try {
        final char = _findCharacteristic(services, uuid);
        await char.onWrite!.call(state.request.value);
        _manager.respondWriteRequest(state.request);
      } catch (e) {
        _manager.respondWriteRequestWithError(
          state.request,
          error: GATTError.unlikelyError,
        );
      }
    });

    await _manager.startAdvertising(
      Advertisement(
        name: appId,
        serviceUUIDs: ganttS.map((s) => s.uuid).toList(),
      ),
    );
  }

  Future<void> stopAdvertising() async {
    await _manager.stopAdvertising();
  }

  BLEVariable _findCharacteristic(List<BLEService> services, UUID uuid) {
    for (var service in services) {
      for (var v in service.variables) {
        final id = this.uuid(service.id, v.id);
        if (id == uuid) return v;
      }
    }
    throw Exception("Characteristic not found");
  }
}
