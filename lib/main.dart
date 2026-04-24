import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

// 🔥 MIC PERMISSION FUNCTION
Future<void> requestMicPermission() async {
  var status = await Permission.microphone.request();

  if (!status.isGranted) {
    print("❌ Mic permission denied");
  } else {
    print("✅ Mic permission granted");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env"); 

  await Firebase.initializeApp();

  await requestMicPermission();

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