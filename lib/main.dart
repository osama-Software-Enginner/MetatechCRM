import 'package:flutter/material.dart';
import 'design_system/theme_manager.dart';
import 'core/navigation.dart';

void main() => runApp(const ClientPortalApp());

class ClientPortalApp extends StatelessWidget {
  const ClientPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => MaterialApp(
        title: 'Client Portal',
        theme: ThemeManager.getTheme(context),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}