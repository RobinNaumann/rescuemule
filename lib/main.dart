import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/connectivity/s_connections.dart';
import 'package:rescuemule/service/networks/bluetooth/s_bluetooth.dart';
import 'package:rescuemule/service/routing/s_routing_first.dart';
import 'package:rescuemule/service/s_networks.dart';
import 'package:rescuemule/view/vp_messaging.dart';

const appName = "RescueMule";

final logger = ConsoleLoggerService();

late final NetworksService networksService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();

  final debugDeviceId = AppInfoService.i.platform.name;

  networksService = NetworksService(
    routing: FirstRoutingManager(),
    connections: ConnectionsManager(
      networks: [
        BluetoothManager.preset(appId: appName, deviceId: debugDeviceId),
      ],
    ),
  );

  runApp(const App());
}

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, _) => const MessagingView())],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      ElbeApp(router: router, debugShowCheckedModeBanner: false);
}
