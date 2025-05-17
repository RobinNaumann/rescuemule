import 'package:elbe/elbe.dart';
import 'package:rescuemule/bit/b_messaging.dart';
import 'package:rescuemule/view/vp_home.dart';
import 'package:rescuemule/view/vp_messaging.dart';

const appName = "RescueMule";
const debugName = "Mac";

final logger = ConsoleLoggerService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();

  runApp(const YourApp());
}

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, _) => const ScaffoldExampleApp()),
    GoRoute(path: '/msg', builder: (context, _) => const MessagingView()),
  ],
);

class YourApp extends StatelessWidget {
  const YourApp({super.key});

  @override
  Widget build(BuildContext context) => BitProvider(
    create: (_) => MessagingBit(),
    child: ElbeApp(router: router),
  );
}
