import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/routing/s_routing.dart';

/// A simple proof-of-concept routing service that
/// always selects the first available device.
class FirstRoutingService extends RoutingService {
  @override
  selectDevice(Message message) {
    // DEMO: send to the first available device
    if (currentDevices.isEmpty) throw Exception("No devices to send to.");
    return currentDevices.first.id;
  }
}
