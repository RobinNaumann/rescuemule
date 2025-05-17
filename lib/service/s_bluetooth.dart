import 'package:desastermule/model/m_ble_service.dart';
import 'package:desastermule/service/ble/s_ble_peripheral.dart';

class BluetoothService {
  static BluetoothService? _i;
  static BluetoothService get i => _i!;

  final String appId;
  late final BLEPeripheralService _pMan;
  final List<String> messageLog = [];
  BluetoothService._(this.appId) {
    _pMan = BLEPeripheralService(appId);
  }

  static init(String appId) {
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
