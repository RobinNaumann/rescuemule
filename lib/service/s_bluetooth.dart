import 'package:rescuemule/model/m_ble_service.dart';
import 'package:rescuemule/service/ble/s_ble_peripheral.dart';

class BluetoothService {
  static BluetoothService? _i;
  static BluetoothService get i => _i!;

  final String appId;
  late final BLEPeripheralManager _pMan;
  final List<String> messageLog = [];
  BluetoothService._(this.appId) {
    _pMan = BLEPeripheralManager(appId);
  }

  static Future<void> init(String appId) async {
    if (_i != null) throw Exception("Service already initialized");
    _i = BluetoothService._(appId);
  }

  Future<void> advertise() async {
    final BLEService service = BLEService(
      id: 1,
      variables: [
        BLEVariable(
          id: 1,
          onWrite: (v) async {
            messageLog.add(String.fromCharCodes(v));
          },
        ),
      ],
    );

    await _pMan.advertise([service]);
  }
}
