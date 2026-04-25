import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // ✅ IMPORTANT
import '../widgets/panic_button.dart';
import '../services/voice_service.dart';
import '../services/emergency_controller.dart';
import 'emergency_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoiceService voiceService = VoiceService();

  bool isVoiceActive = true;

  @override
  void initState() {
    super.initState();

    // ✅ ONLY run voice on mobile
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initVoice();
      });
    }
  }

  Future<void> initVoice() async {
    if (kIsWeb) return; // ❌ safety

    await voiceService.initialize();

    if (isVoiceActive) {
      voiceService.startListening(context);
    }
  }

  void toggleVoice() {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voice feature available on mobile")),
      );
      return;
    }

    setState(() {
      isVoiceActive = !isVoiceActive;
    });

    if (isVoiceActive) {
      voiceService.startListening(context);
    } else {
      voiceService.stop();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      voiceService.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,

      appBar: AppBar(
        title: const Text("Emergency Assistant"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(isVoiceActive ? Icons.mic : Icons.mic_off),
            onPressed: toggleVoice,
          )
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          const Text(
            "Stay Safe 🚨",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 🤖 AI MESSAGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Text(
                EmergencyController.aiMessage ??
                    (kIsWeb
                        ? "Voice not supported on web"
                        : "🎤 Listening... Say 'HELP'"),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 25),

          PanicButton(),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, // ✅ text color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmergencyScreen(),
                    ),
                  );
                },
                child: const Text("Emergency"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white, // ✅ text color
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(),
                    ),
                  );
                },
                child: const Text("Settings"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}