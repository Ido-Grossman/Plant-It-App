import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/logins/login_screen.dart';
import 'package:frontend/service/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppTheme()),
        ChangeNotifierProvider(create: (_) => FontSizeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class AppTheme extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light
        ? ThemeData.dark()
        : ThemeData.light();
    notifyListeners();
  }
}

class FontSizeNotifier extends ChangeNotifier {
  double _fontSize = 16.0;

  double get fontSize => _fontSize;

  void updateFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        theme: appTheme.themeData,
        title: 'Intro Screen',
        home: Login(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
