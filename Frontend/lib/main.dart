import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/logins/loginScreen.dart';
import 'package:frontend/service/googleSignIn.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final lightColorScheme = ColorScheme.light(
  primary: const Color.fromARGB(255, 31, 85, 56),
  secondary: Colors.black54,
  // other colors
);

final darkColorScheme = ColorScheme.dark(
  primary: const Color.fromARGB(255, 31, 85, 56),
  secondary: Colors.white54,
  // other colors
);

final lightTheme = ThemeData.from(colorScheme: lightColorScheme);
final darkTheme = ThemeData.from(colorScheme: darkColorScheme);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppTheme(),
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
        debugShowCheckedModeBanner: false,),
    );
  }
}
