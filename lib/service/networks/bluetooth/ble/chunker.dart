import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/model/m_ble_service.dart';

class Chunker {
  static const int chunkSize = 19;
  // {deviceId: {characteristicId:  [chunks]}}
  final Map<String, Map<String, List<int>>> _chunkCaches = {};
  final List<BLEService> _services;

  Chunker(this._services);

  static Future<void> sendChunks<T>(
    List<int> message,
    Future Function(List<int>) send,
  ) async {
    List<List<int>> chunks = [];
    for (int i = 0; i < message.length; i += chunkSize) {
      final chunk = message.sublist(
        i,
        i + chunkSize > message.length ? message.length : i + chunkSize,
      );
      chunks.add(chunk);
    }

    for (int i = 0; i < chunks.length; i++) {
      final prefix = i == chunks.length - 1 ? 0 : 1;
      final m = [prefix, ...chunks[i]];
      logger.d("Chunker", "Sending chunk ${i + 1}/${chunks.length}");
      await send(m);
    }
  }

  void onReceive(UUID origin, UUID variable, List<int> message) {
    final deviceId = origin.toString();
    final charId = variable.toString();

    // create the cache if it doesn't exist
    if (!_chunkCaches.containsKey(deviceId)) _chunkCaches[deviceId] = {};
    if (!_chunkCaches[deviceId]!.containsKey(charId)) {
      _chunkCaches[deviceId]![charId] = [];
    }

    // if the first byte is 0, we send the whole message onward
    if (message.first == 0) {
      final m = [..._chunkCaches[deviceId]![charId]!, ...message.sublist(1)];
      _chunkCaches[deviceId]![charId] = [];
      final handler = findCharacteristicByUUID(_services, variable);
      if (handler.onWrite == null) {
        logger.w(this, "No write handler for ${variable.toString()}");
        return;
      }

      handler.onWrite!(origin, m);
      return;
    }

    _chunkCaches[deviceId]![charId]!.addAll(message.sublist(1));
  }
}
