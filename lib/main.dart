import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/s_bluetooth.dart';
import 'package:rescuemule/view/vp_home.dart';

const appName = "RescueMule";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();
  await BluetoothService.init(appName);
  runApp(const YourApp());
}

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, _) => const HomePage())],
);

class YourApp extends StatelessWidget {
  const YourApp({super.key});

  @override
  Widget build(BuildContext context) => ElbeApp(router: router);
}
