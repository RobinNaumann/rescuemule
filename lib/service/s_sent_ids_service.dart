import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/view/v_message_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sentIDsService = SentIDsService();

class SentIDsService {
  // Stores a list of IDs for a given mac
  Future<void> saveSentIDs(String mac, List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = ids.map((id) => id.toString()).toList();
    await prefs.setStringList((mac), idStrings);
  }

  // Loads the list of IDs for a given String
  Future<List<int>> loadSentIDs(String mac) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList((mac)) ?? [];
    return idStrings.map((id) => int.tryParse(id) ?? 0).toList();
  }

  // Adds a single ID to the list for a given String
  Future<void> addSentID(String mac, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList((mac)) ?? [];
    if (!idStrings.contains(id.toString())) {
      idStrings.add(id.toString());
      await prefs.setStringList((mac), idStrings);
    }
  }

  // Removes a single ID from the list for a given String
  Future<void> removeSentID(String mac, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList((mac)) ?? [];
    idStrings.remove(id.toString());
    await prefs.setStringList((mac), idStrings);
  }

  // Clears all IDs for a given String
  Future<void> clearSentIDs(String mac) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove((mac));
  }

  /// Removes the given [id] from all String lists in SharedPreferences.
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

  /// For a given [message], saves its id to the sent list for each hop String.
  Future<void> saveMessageIdForHops(Message message) async {
    final prefs = await SharedPreferences.getInstance();
    for (final hop in message.hops) {
      // Each hop is assumed to be a String string
      final List<String> idStrings = prefs.getStringList(hop) ?? [];
      if (!idStrings.contains(message.id.toString())) {
        idStrings.add(message.id.toString());
        await prefs.setStringList(hop, idStrings);
      }
    }
  }
}