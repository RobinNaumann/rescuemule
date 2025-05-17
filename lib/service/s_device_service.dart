import 'package:shared_preferences/shared_preferences.dart';

class DeviceService {
  

  Future<List<int>> getAlreadySentIDs(String deviceID) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(deviceID) ?? [];
    return idStrings.map((id) => int.tryParse(id) ?? 0).toList();
  }
  Future<void> addSentID(String deviceID, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(deviceID) ?? [];
    idStrings.add(id.toString());
    await prefs.setStringList(deviceID, idStrings);
  }
  Future<void> clearSentIDs(String deviceID, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> idStrings = prefs.getStringList(deviceID) ?? [];
    idStrings.remove(id.toString());
    await prefs.setStringList(deviceID, idStrings);
  }
}