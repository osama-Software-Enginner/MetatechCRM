import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'design_system/theme_manager.dart';
import 'core/navigation.dart';
import 'features/invoice/InvoiceScreen.dart';
import 'features/invoice/bloc/InvoiceBloc.dart';
import 'features/invoice/bloc/InvoiceEvent.dart';
import 'features/support/bloc/chat_bloc.dart';
import 'firebase_options.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClientPortalApp());
}

class ClientPortalApp extends StatelessWidget {
  const ClientPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) => DashboardBloc(),
        ),

        BlocProvider(create: (_) => ChatBloc()),

        BlocProvider<InvoiceBloc>( // ✅ Provide InvoiceBloc here
          create: (context) => InvoiceBloc()..add(LoadInvoices()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Metatech Client Portal',
        theme: ThemeManager.getTheme(context),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
