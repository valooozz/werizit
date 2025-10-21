import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rangement/presentation/screens/home_screen.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('fr'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rangement',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: HomeScreen(),
    );
  }
}
