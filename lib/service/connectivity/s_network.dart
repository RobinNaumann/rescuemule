import 'dart:async';

import 'package:elbe/elbe.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_message.dart';

abstract class NetworkManager {
  String get key;
  Stream<List<String>> get hardwareDevices;

  /// A mapping of device IDs to hardware identifiers.<br>
  /// ```deviceId: hardwareId```
  Map<String, String> hardwareMappings = {};
  Stream<Message> get messages;
  Future<List<String>> send(String device, List<Message> messages);
  Future<void> dispose();

  /// A stream of devices that are currently available on the network.
  /// This stream will emit a list of device IDs (as strings) that are
  /// currently connected to the network.
  /// The device IDs are mapped to their hardware identifiers using
  /// [hardwareMappings].
  /// If a device ID is not found in the [hardwareMappings],
  /// the [getDeviceId] method will be called to retrieve the hardware ID.
  Stream<List<String>> get devices => hardwareDevices.asyncMap((ds) async {
    final List<String> devs = [];
    for (final d in ds) {
      try {
        devs.add(await _getDeviceId(d));
      } catch (e) {
        logger.v(this, "Failed to get device ID for $d", e);
      }
    }

    // remove all unused mappings
    hardwareMappings.removeWhere((key, value) => !devs.contains(key));

    return devs;
  });

  Future<String> _getDeviceId(String hardwareId) async {
    var entry = hardwareMappings.entries.firstWhereOrNull(
      (e) => e.value == hardwareId,
    );
    if (entry != null) return entry.key;

    final devId = await getDeviceId(hardwareId);
    hardwareMappings[devId] = hardwareId;
    return devId;
  }

  /// get the device ID for a given hardware ID.
  Future<String> getDeviceId(String hardwareId);
}
