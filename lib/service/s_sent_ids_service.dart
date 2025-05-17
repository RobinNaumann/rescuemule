import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SentIDsService {
  // Stores a list of IDs for a given UUID
  Future<void> saveSentIDs(UUID uuid, List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = ids.map((id) => id.toString()).toList();
    await prefs.setStringList(uuid.toString(), idStrings);
  }

  // Loads the list of IDs for a given UUID
  Future<List<int>> loadSentIDs(UUID uuid) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(uuid.toString()) ?? [];
    return idStrings.map((id) => int.tryParse(id) ?? 0).toList();
  }

  // Adds a single ID to the list for a given UUID
  Future<void> addSentID(UUID uuid, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(uuid.toString()) ?? [];
    if (!idStrings.contains(id.toString())) {
      idStrings.add(id.toString());
      await prefs.setStringList(uuid.toString(), idStrings);
    }
  }

  // Removes a single ID from the list for a given UUID
  Future<void> removeSentID(UUID uuid, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(uuid.toString()) ?? [];
    idStrings.remove(id.toString());
    await prefs.setStringList(uuid.toString(), idStrings);
  }

  // Clears all IDs for a given UUID
  Future<void> clearSentIDs(UUID uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(uuid.toString());
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
}