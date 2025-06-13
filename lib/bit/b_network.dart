import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_device_id.dart';
import 'package:rescuemule/main.dart';
import 'package:rescuemule/service/connectivity/s_connections.dart';
import 'package:rescuemule/service/networks/bluetooth/s_bluetooth.dart';
import 'package:rescuemule/service/routing/s_routing_first.dart';
import 'package:rescuemule/service/s_networks.dart';

class NetworksBit extends SimpleBit<NetworksService> {
  static NetworksService? _instance;
  static int? _hashCode;
  static const builder = SimpleBitBuilder<NetworksService, NetworksBit>.make;

  NetworksBit(AppConfig config)
    : super.worker((_) async {
        print("WHY RECREATE NETWORKS BIT?");

        if (config.hashCode == _hashCode && _instance != null) {
          return _instance!;
        }

        _hashCode = config.hashCode;
        await _instance?.dispose();
        return _instance = NetworksService(
          routing: FirstRoutingManager(),
          connections: ConnectionsManager(
            networks: [
              BluetoothManager.preset(
                appId: appName,
                deviceId: config.deviceId,
              ),
            ],
          ),
        );
      });
}
