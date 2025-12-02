import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'gen/assets.gen.dart';
import 'src/core/di/service_locator.dart';
import 'src/core/navigation/app_router.dart';
import 'src/core/retry/retry_notifier.dart';
import 'src/core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize dependencies
  await initializeDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RetryNotifier>.value(
      value: sl<RetryNotifier>(),
      child: MaterialApp.router(
        title: 'HR TCC Project',
        routerConfig: AppRouter.router,
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: const Color(0xFFF2F2F6),
          appBarTheme: AppBarTheme.of(context).copyWith(
            titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            iconTheme: IconThemeData(color: Color(0xFF767679)),
            centerTitle: true,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            surfaceTintColor: AppColors.transparent,
          ),
          actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (context) {
              return SvgPicture.asset(Assets.icons.backIcon);
            },
          ),
          // Ensure Android-style page transitions (slide up from bottom)
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );
  }
}
