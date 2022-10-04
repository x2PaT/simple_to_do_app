import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_to_do_app/features/auth_gate/auth_gate.dart';
import 'package:simple_to_do_app/firebase_options.dart';
import 'package:simple_to_do_app/models/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppPreferences(),
        ),
      ],
      child: Consumer<AppPreferences>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Simple To Do App',
            theme: value.darkTheme ? darkThemeValues : lightThemeValues,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
