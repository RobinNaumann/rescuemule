import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/s_bluetooth.dart';

const appName = "RescueMule";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();
  await BluetoothService.init(appName);
  runApp(const YourApp());
}

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, _) => const YourPage())],
);

class YourApp extends StatelessWidget {
  const YourApp({super.key});

  @override
  Widget build(BuildContext context) => ElbeApp(router: router);
}

class YourPage extends StatelessWidget {
  const YourPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    title: appName,
    child: Padded.all(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children:
            [
              Button.minor(
                label: "advertise",
                onTap: () async {
                  context.showToast("TODO: advertise");
                  //await advertise();
                },
              ),
              Button.minor(
                label: "scan",
                onTap: () async {
                  context.showToast("TODO: discover");
                  //await discover();
                },
              ),
              Mule(name: "Jonas"),
            ].spaced(),
      ),
    ),
  );
}

class Mule extends StatelessWidget {
  final String name;
  const Mule({super.key, this.name = "Unknown Mule"});

  @override
  Widget build(BuildContext context) {
    return Text("Hello I'm the mule $name");
  }
}
