import 'dart:async';

import 'package:elbe/bit/bit/bit_control.dart';
import 'package:rescuemule/service/s_bluetooth.dart';

final messages = <String>[];
bool initialized = false;

class MsgsBit extends MapMsgBitControl<List<String>> {
  StreamSubscription? _subscription;
  static const builder = MapMsgBitBuilder<List<String>, MsgsBit>.make;

  MsgsBit() : super.worker((_) async => []) {
    if (!initialized) BluetoothService.i.advertise();
    initialized = true;
    _subscription = BluetoothService.i.messageStream.stream.listen((v) {
      messages.add(v.toString());
      emit(messages);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
