import 'package:flutter/material.dart';
import '../widgets/panic_button.dart';
import '../services/voice_service.dart';
import '../services/emergency_controller.dart';
import 'emergency_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key}); // ❌ const हटाया

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VoiceService voiceService = VoiceService();

  bool isVoiceActive = true;

  @override
  void initState() {
    super.initState();

    // 🔥 SAFE START
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initVoice();
    });
  }

  Future<void> initVoice() async {
    await voiceService.initialize(); // ✅ new simple init

    if (isVoiceActive) {
      voiceService.startListening(context); // ✅ continuous listening
    }
  }

  void toggleVoice() {
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
    voiceService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,

      appBar: AppBar(
        title: Text("Emergency Assistant"), // ❌ const हटाया
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
          SizedBox(height: 20),

          Text(
            "Stay Safe 🚨",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          // 🤖 AI MESSAGE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Text(
                EmergencyController.aiMessage ??
                    "🎤 Listening... Say 'HELP'",
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: 25),

          PanicButton(),

          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmergencyScreen(), // ❌ const हटाया
                    ),
                  );
                },
                child: Text("Emergency"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(), // ❌ const हटाया
                    ),
                  );
                },
                child: Text("Settings"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}