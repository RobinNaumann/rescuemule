import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_device_id.dart';
import 'package:rescuemule/bit/b_network.dart';
import 'package:rescuemule/view/demo/vp_demo.dart';

const appName = "RescueMule";

final logger = ConsoleLoggerService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();

  runApp(const App());
}

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, _) => const MessagingView())],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BitProvider(
    create:
        (_) => AppConfigBit(
          AppConfig(deviceId: "a_${AppInfoService.i.platform.name}_device"),
        ),
    child: AppConfigBit.builder(
      onData:
          (bit, data) => BitProvider(
            key: ValueKey(data.hashCode),
            create: (_) => NetworksBit(data),
            child: ElbeApp(router: router, debugShowCheckedModeBanner: false),
          ),
    ),
  );
}
