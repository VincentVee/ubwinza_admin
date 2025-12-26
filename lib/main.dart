import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubwinza_admin_dashboard/features/auth/login_screen.dart';
import 'package:ubwinza_admin_dashboard/view/auth_check_screen.dart';
import 'package:ubwinza_admin_dashboard/view/main_screens/home_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // or with options for web
  runApp(const UbwinzaAdminApp());
}


class UbwinzaAdminApp extends StatelessWidget {
  const UbwinzaAdminApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ubwinza Admin',
      theme: ThemeData.dark(useMaterial3: true),
      home: const AuthCheckScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}