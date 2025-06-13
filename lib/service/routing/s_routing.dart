import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/connectivity/s_connections.dart';
import 'package:rescuemule/util/util.dart';

class RoutingContext {
  final ConnectionsManager _c;

  RoutingContext(this._c);

  /// A stream of all devices currently connected to the network.
  /// if you want a snapshot of the current devices, use [currentDevices].
  Stream<List<NetworkDevice>> get devices => _c.devices;
  List<NetworkDevice> get currentDevices => _c.currentDevices();

  /// A stream of incoming messages.
  Stream<Message> get received => _c.received;

  /// Send a message to the network. The routing service
  void send(DeviceId deviceId, List<Message> messages) =>
      _c.send(deviceId, messages);
}

abstract class RoutingManager {
  RoutingManager();
  late final RoutingContext context;
  init(ConnectionsManager c) => context = RoutingContext(c);

  /// Selects a device to send the message to.
  DeviceId selectDevice(Message message);

  /// give the router a name for debugging purposes
  String get name => toSnakeCase(
    runtimeType.toString(),
  ).replaceAll("_routing_manager", "").replaceAll("_manager", "");

  /// Called when the routing service is no longer needed.
  /// This is called when the [NetworksService] is disposed.
  void dispose() {}

  /// Called when a message is received.
  /// This can be used to filter out messages that are not relevant
  /// outside of the routing service.
  ///
  /// Defaults to letting all messages pass through.
  bool onReceive(Message message) => true;
}
