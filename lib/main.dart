import 'package:elbe/elbe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();
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
    title: "DisasterMule",
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
            ].spaced(),
      ),
    ),
  );
}
