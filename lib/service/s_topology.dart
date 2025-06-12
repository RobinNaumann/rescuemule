import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/networks/s_connections.dart';
import 'package:rescuemule/service/routing/s_routing.dart';

class TopologyService {
  final ConnectionsService _connections;
  final RoutingService _routing;

  TopologyService({
    required ConnectionsService connections,
    required RoutingService routing,
  }) : _routing = routing,
       _connections = connections {
    _routing.init(_connections.devices, _connections.currentDevices);
  }

  /// A stream of all devices currently connected to the network.
  late Stream<List<NetworkDevice>> devices = _connections.devices;

  /// A stream of incoming messages.
  late Stream<Message> received = _connections.received;

  /// send a message to the network. The routing service
  /// will determine the next hop to send the message to.
  void send(Message message) async {
    try {
      final deviceId = _routing.selectDevice(message);
      _connections.send(deviceId, [message]);
    } catch (e) {
      throw StateError("could not send message: $e");
    }
  }

  // ======= demo functions to show the capabilities =======

  final List<Message> _demoAllReceived = [];

  /// A stream of all messages received by the current device.
  late Stream<List<Message>> demoAllReceived =
      _connections.received.map((m) {
        _demoAllReceived.add(m);
        return _demoAllReceived;
      }).asBroadcastStream();
}
