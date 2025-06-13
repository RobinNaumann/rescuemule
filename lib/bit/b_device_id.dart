import 'package:elbe/elbe.dart';

class AppConfig extends JsonModel {
  final String deviceId;
  AppConfig({required String deviceId})
    : deviceId =
          deviceId
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), "_")
              .toLowerCase()
              .trim();

  @override
  get map => {"deviceId": deviceId};

  AppConfig copyWith({String? deviceId}) =>
      AppConfig(deviceId: deviceId ?? this.deviceId);
}

class AppConfigBit extends SimpleBit<AppConfig> {
  static const builder = SimpleBitBuilder<AppConfig, AppConfigBit>.make;

  AppConfigBit(AppConfig initial)
    : super.worker((_) => initial, initial: initial);

  set(AppConfig config) => state.whenOrNull(onData: (v) => this.emit(config));
}
