import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/view/v_message_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sentIDsService = SentIDsService();

class SentIDsService {
  //Todo uuid anyways converted to mac so could change interface to accept strings (mac)
  // Stores a list of IDs for a given uuid
  Future<void> saveSentIDs(UUID uuid, List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = ids.map((id) => id.toString()).toList();
    await prefs.setStringList(formatMacFromUUID(uuid), idStrings);
  }

  // Loads the list of IDs for a given UUID
  Future<List<int>> loadSentIDs(UUID uuid) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(formatMacFromUUID(uuid)) ?? [];
    return idStrings.map((id) => int.tryParse(id) ?? 0).toList();
  }

  // Adds a single ID to the list for a given UUID
  Future<void> addSentID(UUID uuid, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(formatMacFromUUID(uuid)) ?? [];
    if (!idStrings.contains(id.toString())) {
      idStrings.add(id.toString());
      await prefs.setStringList(formatMacFromUUID(uuid), idStrings);
    }
  }

  // Removes a single ID from the list for a given UUID
  Future<void> removeSentID(UUID uuid, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(formatMacFromUUID(uuid)) ?? [];
    idStrings.remove(id.toString());
    await prefs.setStringList(formatMacFromUUID(uuid), idStrings);
  }

  // Clears all IDs for a given UUID
  Future<void> clearSentIDs(UUID uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(formatMacFromUUID(uuid));
  }

  /// Removes the given [id] from all UUID lists in SharedPreferences.
  Future<void> removeExpiredID(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      final List<String>? idStrings = prefs.getStringList(key);
      if (idStrings != null && idStrings.contains(id.toString())) {
        idStrings.remove(id.toString());
        await prefs.setStringList(key, idStrings);
      }
    }
  }

  /// For a given [message], saves its id to the sent list for each hop UUID.
  Future<void> saveMessageIdForHops(Message message) async {
    final prefs = await SharedPreferences.getInstance();
    for (final hop in message.hops) {
      // Each hop is assumed to be a UUID string
      final List<String> idStrings = prefs.getStringList(hop) ?? [];
      if (!idStrings.contains(message.id.toString())) {
        idStrings.add(message.id.toString());
        await prefs.setStringList(hop, idStrings);
      }
    }
  }
}