import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BleCentralManager {
  final _manager = CentralManager();

  Future<void> scan(List<int> services) async {
    _manager.startDiscovery(serviceUUIDs: [makeUUID(1)]);
  }
}
