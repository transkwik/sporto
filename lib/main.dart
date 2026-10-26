import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sporto/screens/auth/providers/auth_provider.dart';
import 'package:sporto/screens/onboarding/providers/profile_provider.dart';
import 'package:sporto/screens/onboarding/providers/permission_provider.dart';
import 'package:sporto/screens/auth/providers/location_provider.dart';
import 'package:sporto/screens/home/providers/home_provider.dart';
import 'package:sporto/screens/profile/prizes/providers/my_prizes_provider.dart';
import 'package:sporto/screens/profile/prizes/providers/prize_distribution_provider.dart';
import 'package:sporto/screens/profile/wallet/providers/wallet_provider.dart';
import 'package:sporto/screens/profile/bank/providers/bank_provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => PermissionProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => MyPrizesProvider()),
        ChangeNotifierProvider(create: (_) => PrizeDistributionProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => BankProvider()),
      ],
      child: const SportoApp(),
    ),
  );
}

class SportoApp extends StatelessWidget {
  const SportoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'Spoto',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
