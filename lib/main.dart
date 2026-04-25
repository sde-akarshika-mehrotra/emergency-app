import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart'; 
import 'screens/home_screen.dart';

// 🔥 Mic permission (only for mobile)
Future<void> requestMicPermission() async {
  if (!kIsWeb) {
    print("Mic permission works only on mobile");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load env
  await dotenv.load(fileName: ".env");

 await Firebase.initializeApp();

  // 🔥 Only run mic permission on mobile
  if (!kIsWeb) {
    await requestMicPermission();
  }

  runApp(const EmergencyApp());
}

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Assistant',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.red.shade50,
      ),
      home: HomeScreen(),
    );
  }
}