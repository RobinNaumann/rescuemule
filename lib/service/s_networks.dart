import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/connectivity/s_connections.dart';
import 'package:rescuemule/service/routing/s_routing.dart';

/// A service that manages the network topology.
/// It provides a stream of all devices currently connected to the network,
/// and a stream of incoming messages.
/// You can send messages to the network, and the routing service
class NetworksService {
  final ConnectionsManager _connections;
  final RoutingManager _routing;

  NetworksService({
    required ConnectionsManager connections,
    required RoutingManager routing,
  }) : _routing = routing,
       _connections = connections {
    _routing.init(_connections);
  }

  /// A stream of all devices currently connected to the network.
  late Stream<List<NetworkDevice>> devices = _connections.devices;

  /// A stream of incoming messages.
  late Stream<Message> received = _connections.received.where(
    (m) => _routing.onReceive(m),
  );

  /// send a message to the network. The routing service
  /// will determine the next hop to send the message to.
  void send(Message message) {
    try {
      final deviceId = _routing.selectDevice(message);
      _connections.send(deviceId, [message]);
    } catch (e) {
      throw Exception("could not send message: $e");
    }
  }

  // ======= demo functions to show the capabilities =======

  /// close the service and dispose of the connections and routing manager.
  /// The service wil no longer work after this call.
  Future<void> dispose() async {
    await _connections.dispose();
    _routing.dispose();
  }
}
