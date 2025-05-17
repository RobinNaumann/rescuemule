import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BLEVariable<T> {
  final int id;
  final String? label;
  final Function(List<int> bytes)? onWrite;
  final Future<List<int>> Function()? onRead;

  BLEVariable({required this.id, this.label, this.onWrite, this.onRead});

  GATTCharacteristic asGATT(BLEPeripheralManager s, int serviceId) =>
      GATTCharacteristic.mutable(
        uuid: s.uuid(serviceId, id),
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

  GATTService asGATT(BLEPeripheralManager s) {
    return GATTService(
      uuid: s.uuid(id),
      isPrimary: true,
      includedServices: [],
      characteristics: variables.map((v) => v.asGATT(s, id)).toList(),
    );
  }
}
