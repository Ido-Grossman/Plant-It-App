import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/intro/intro_screen.dart';
import 'package:frontend/logins/login_screen.dart';
import 'package:frontend/service/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
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
        home: InitialScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool? _showIntro;

  @override
  void initState() {
    super.initState();
    _checkIntroStatus();
  }

  Future<void> _checkIntroStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showIntro = prefs.getBool('introScreen') ?? true;

    if (showIntro) {
      await prefs.setBool('introScreen', false);
    }

    setState(() {
      _showIntro = showIntro;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _showIntro! ? const IntroScreen() : const Login();
  }
}
