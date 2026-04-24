import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'emergency_controller.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();

  bool isListening = false;
  bool isInitialized = false;
  bool isTriggered = false;
  BuildContext? context;

  // 🎤 PERMISSION
  Future<void> requestMicPermission() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      print("❌ Mic permission denied");
    } else {
      print("✅ Mic permission granted");
    }
  }

  // 🔥 INIT
  Future<void> initialize() async {
    await requestMicPermission();

    if (isInitialized) return;

    isInitialized = await _speech.initialize(
      onStatus: (status) {
        print("STATUS: $status");
      },
      onError: (error) {
        print("VOICE ERROR: $error");
      },
    );
  }

  // 🔥 CONTINUOUS LISTEN (FIXED)
  Future<void> startListening(BuildContext ctx) async {
    context = ctx;

    if (!isInitialized || isListening) return;

    isListening = true;

    while (isListening) {
      try {
        await _speech.listen(
          listenMode: ListenMode.dictation,
          listenFor: const Duration(seconds: 15),
          pauseFor: const Duration(seconds: 5),

          onResult: (result) async {
            String text = result.recognizedWords.toLowerCase();

            print("VOICE: $text");

            if ((text.contains("help") ||
                    text.contains("save me") ||
                    text.contains("bachao")) &&
                !isTriggered) {

              isTriggered = true;

              print("🚨 EMERGENCY TRIGGERED");

              await EmergencyController.triggerEmergency(context!);

              stop();

              // cooldown
              await Future.delayed(const Duration(seconds: 8));
              isTriggered = false;
              startListening(context!);
            }
          },
        );

        // ⏳ wait before restart (IMPORTANT)
        await Future.delayed(const Duration(seconds: 1));

      } catch (e) {
        print("❌ Listen crash: $e");
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // 🔥 STOP
  void stop() {
    isListening = false;
    _speech.stop();
  }
}