import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'emergency_controller.dart';

class VoiceService {
  bool isListening = false;
  bool isInitialized = false;
  bool isTriggered = false;
  BuildContext? context;

  // 🔥 INIT (SAFE)
  Future<void> initialize() async {
    if (kIsWeb) {
      print("Voice disabled on web");
      return;
    }

    isInitialized = true;
  }

  // 🔥 LISTEN (WEB SAFE MOCK)
  Future<void> startListening(BuildContext ctx) async {
    context = ctx;

    // ❌ WEB: DO NOTHING (PREVENT CRASH)
    if (kIsWeb) {
      print("Voice feature not supported on web");
      return;
    }

    if (!isInitialized || isListening) return;

    isListening = true;

    while (isListening) {
      try {
        // 🔴 REAL VOICE CODE SHOULD BE HERE (mobile only)

        // Simulated behavior (safe fallback)
        await Future.delayed(const Duration(seconds: 3));

        print("🎤 Listening... (mobile only)");

      } catch (e) {
        print("Voice error: $e");
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // 🔥 STOP
  void stop() {
    isListening = false;
  }
}