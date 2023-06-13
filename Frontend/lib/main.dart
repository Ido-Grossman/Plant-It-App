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

    // Persist theme preference
    _saveThemePreference(_themeData.brightness == Brightness.dark);

    notifyListeners();
  }

  _saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<bool> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false; // Use light theme by default
  }

  void setTheme(ThemeData theme) {
    _themeData = theme;

    // Persist theme preference
    _saveThemePreference(theme.brightness == Brightness.dark);

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTheme();
  }

  void loadTheme() async {
    Future.microtask(() async {
      final appTheme = Provider.of<AppTheme>(context, listen: false);
      final isDarkMode = await appTheme.loadThemePreference();
      if (isDarkMode) {
        appTheme.setTheme(ThemeData.dark());
      } else {
        appTheme.setTheme(ThemeData.light());
      }
    });
  }



  Future<void> _checkIntroStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showIntro = prefs.getBool('intro_screen') ?? true;

    if (showIntro) {
      await prefs.setBool('intro_screen', false);
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
