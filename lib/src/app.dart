import 'package:chat_app/src/controllers/navigation/navigation_service.dart';
import 'package:chat_app/src/screens/authentication/auth_screen.dart';
import 'package:flutter/material.dart';

import '../service_locators.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      builder: (context, Widget? child) => child as Widget,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: AuthScreen.route,
    );
  }

}