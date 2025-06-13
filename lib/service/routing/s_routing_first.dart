import 'package:rescuemule/model/m_message.dart';
import 'package:rescuemule/service/routing/s_routing.dart';

/// A simple proof-of-concept routing service that
/// always selects the first available device.
class FirstRoutingManager extends RoutingManager {
  @override
  selectDevice(Message message) {
    // DEMO: send to the first available device
    if (context.currentDevices.isEmpty) throw Exception("No devices found");
    return context.currentDevices.first.id;
  }
}
