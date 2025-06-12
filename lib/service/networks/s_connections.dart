import 'dart:async';

import 'package:elbe/elbe.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/networks/s_bluetooth.dart';

class NetworkDevice extends JsonModel {
  final DeviceId id;
  final String network;
  final UnixMs lastSeen;

  NetworkDevice({required this.id, required this.network})
    : lastSeen = DateTime.now().asUnixMs;

  @override
  get map => {"id": id, "network": network, "lastSeen": lastSeen};
}

class ConnectionsService {
  /// how long to remember devices in the pool
  final int memoryMs;
  final List<NetworkService> networks;
  final Map<DeviceId, List<Message>> _sendPool = {};
  final List<StreamSubscription> _devListeners = [];
  final List<StreamSubscription> _msgListeners = [];

  List<NetworkDevice> _devices = [];

  List<NetworkDevice> currentDevices() =>
      _devices
          .where((d) => d.lastSeen > DateTime.now().asUnixMs - memoryMs)
          .toList();

  final StreamController<List<NetworkDevice>> _devicesCtrl =
      StreamController.broadcast();

  Stream<List<NetworkDevice>> get devices => _devicesCtrl.stream;

  final StreamController<Message> _recieveCtrl = StreamController.broadcast();
  Stream<Message> get received => _recieveCtrl.stream;

  ConnectionsService({required this.networks, this.memoryMs = 30 * 1000}) {
    // register listeners
    for (final n in networks) {
      _devListeners.add(
        n.devices.listen((ds) {
          _updateDevices(n.key, ds);
          _onDeviceDiscovery(ds, n.send);
        }),
      );
    }

    for (final n in networks) {
      _msgListeners.add(n.messages.listen((d) => _recieveCtrl.add(d)));
    }
  }

  /// Method to send a message
  void send(DeviceId device, List<Message> messages) => _sendPool.addAll({
    device: [...(_sendPool[device] ?? []), ...messages],
  });

  Future<void> _onDeviceDiscovery(List<DeviceId> devices, SendFn send) async {
    for (var device in devices) {
      final List<Message<dynamic>> msgs = _sendPool[device] ?? [];
      if (msgs.isEmpty) continue;
      final res = await send(device, msgs);

      // remove sent messages from the pool
      _sendPool[device]?.removeWhere((m) => res.contains(m.id));
    }
  }

  void _updateDevices(String network, List<DeviceId> devices) {
    _devices = [
      ...currentDevices().where((d) => d.network != network),
      ...devices.map((d) => NetworkDevice(id: d, network: network)),
    ];
    _devicesCtrl.add(_devices);
  }

  void dispose() {
    _devListeners.forEach((l) => l.cancel());
    _msgListeners.forEach((l) => l.cancel());
  }
}
