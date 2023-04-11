import 'package:flutter_downloader/flutter_downloader.dart';
import '../../libs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(
    const IEducationAdmin(),
  );
}

class IEducationAdmin extends StatelessWidget {
  const IEducationAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: kPrimaryColor),
      child: ScreenUtilInit(
        designSize: const Size(360, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            navigatorKey: NavigationUtilities.key,
            onGenerateRoute: onGenerateRoute,
            navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
