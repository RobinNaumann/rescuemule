import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/networks/s_bluetooth.dart';
import 'package:rescuemule/service/networks/s_connections.dart';
import 'package:rescuemule/service/routing/s_routing_first.dart';
import 'package:rescuemule/service/s_topology.dart';
import 'package:rescuemule/view/vp_messaging.dart';

const appName = "RescueMule";
const debugName = "Mac";

final logger = ConsoleLoggerService();

//late final ConnectionsService connectionsService;
late final TopologyService topologyService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();

  final bluetoothService = BluetoothService.preset(appId: appName);
  topologyService = TopologyService(
    connections: ConnectionsService(networks: [bluetoothService]),
    routing: FirstRoutingService(),
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
