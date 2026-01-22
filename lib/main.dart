import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'gen/assets.gen.dart';
import 'src/core/di/bloc_factory.dart';
import 'src/core/di/service_locator.dart';
import 'src/core/files/files_service.dart';
import 'src/core/navigation/app_router.dart';
import 'src/core/retry/retry_notifier.dart';
import 'src/core/theme/theme.dart';
import 'src/features/auth/presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize dependencies
  await initializeDependencies();

  // Check auth status on app start
  BlocFactory.getAuthBloc().add(const AuthEvent.checkAuthStatus());

  // Cleanup expired file cache (runs in background, doesn't block startup)
  sl<FilesService>().cleanupExpiredCache();

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
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context).copyWith(
          scaffoldBackgroundColor: AppColors.grey100,
          appBarTheme: AppBarTheme.of(context).copyWith(
            titleTextStyle: AppTypography.titleBold4.black,
            iconTheme: IconThemeData(color: AppColors.grey700),
            centerTitle: true,
            backgroundColor: AppColors.white,
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
