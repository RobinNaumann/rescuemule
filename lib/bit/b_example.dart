import 'package:elbe/bit/bit/bit_control.dart';

typedef _Data = String;

class ExampleBit extends MapMsgBitControl<_Data> {
  static const builder = MapMsgBitBuilder<_Data, ExampleBit>.make;

  ExampleBit() : super.worker((_) async => "");
}
