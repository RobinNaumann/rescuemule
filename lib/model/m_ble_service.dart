import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BLEVariable<T> {
  final int id;
  final String? label;
  final Function(UUID origin, List<int> bytes)? onWrite;
  final Future<List<int>> Function(UUID origin)? onRead;

  BLEVariable({required this.id, this.label, this.onWrite, this.onRead});

  GATTCharacteristic asGATT(int serviceId) => GATTCharacteristic.mutable(
    uuid: makeUUID(serviceId, id),
    properties: [
      if (onRead != null) GATTCharacteristicProperty.read,
      if (onWrite != null) GATTCharacteristicProperty.write,
    ],

    permissions: [
      if (onRead != null) GATTCharacteristicPermission.read,
      if (onWrite != null) GATTCharacteristicPermission.write,
    ],
    descriptors: [],
  );
}

class BLEService {
  final int id;
  final String? label;
  final List<BLEVariable> variables;

  BLEService({required this.id, this.label, this.variables = const []});

  GATTService asGATT() {
    return GATTService(
      uuid: makeUUID(id),
      isPrimary: true,
      includedServices: [],
      characteristics: variables.map((v) => v.asGATT(id)).toList(),
    );
  }
}

GATTCharacteristic makeDemoChar(int serviceId, int id, bool write) =>
    GATTCharacteristic.mutable(
      uuid: makeUUID(serviceId, id),
      properties: [
        write
            ? GATTCharacteristicProperty.write
            : GATTCharacteristicProperty.read,
      ],

      permissions: [
        write
            ? GATTCharacteristicPermission.write
            : GATTCharacteristicPermission.read,
      ],
      descriptors: [],
    );

BLEVariable findCharacteristicByUUID(List<BLEService> services, UUID uuid) {
  for (var service in services) {
    for (var v in service.variables) {
      final id = makeUUID(service.id, v.id);
      if (id == uuid) return v;
    }
  }
  throw Exception("Characteristic not found");
}
