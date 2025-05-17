import 'package:elbe/elbe.dart';
import 'package:rescuemule/service/s_sending_service.dart';
import 'package:rescuemule/view/vp_home.dart';
import 'package:rescuemule/view/vp_messaging.dart';

const appName = "RescueMule";
const debugName = "Mac";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfoService.init();
  //SendingService sendingService = SendingService();
  //sendingService.registerListener();
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
  Widget build(BuildContext context) => ElbeApp(router: router);
}
