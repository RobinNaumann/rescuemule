import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/networks/s_connections.dart';

abstract class RoutingService {
  RoutingService();
  Stream<List<NetworkDevice>>? _devices;
  late final List<NetworkDevice> Function()? _currentFn;
  List<NetworkDevice> get currentDevices => _currentFn?.call() ?? [];
  Stream<List<NetworkDevice>>? get devices =>
      _devices ?? (throw StateError("RoutingService not initialized"));

  init(
    Stream<List<NetworkDevice>> devices,
    List<NetworkDevice> Function() currentFn,
  ) {
    if (_devices != null) throw StateError("RoutingService is initialized");
    _devices = devices;
    _currentFn = currentFn;
  }

  /// Selects a device to send the message to.
  DeviceId selectDevice(Message message);
}
