import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'emergency_controller.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();

  bool isListening = false;
  bool isInitialized = false;
  bool isTriggered = false;
  BuildContext? context;

  // 🔥 INIT
  Future<void> initialize() async {
    if (kIsWeb) {
      print("Voice disabled on web");
      return;
    }

    // 🔥 REQUEST MIC PERMISSION
    var status = await Permission.microphone.request();

    if (!status.isGranted) {
      print("❌ Mic permission denied");
      return;
    }

    // 🔥 INIT SPEECH
    isInitialized = await _speech.initialize(
      onStatus: (status) {
        print("STATUS: $status");
      },
      onError: (error) {
        print("VOICE ERROR: $error");
      },
    );

    print("🎤 Voice initialized: $isInitialized");
  }

  // 🔥 START LISTENING
  Future<void> startListening(BuildContext ctx) async {
    context = ctx;

    if (kIsWeb) {
      print("Voice not supported on web");
      return;
    }

    if (!isInitialized || isListening) return;

    isListening = true;

    while (isListening) {
      try {
        await _speech.listen(
          listenFor: const Duration(seconds: 10),
          pauseFor: const Duration(seconds: 3),
          listenMode: ListenMode.dictation,

          onResult: (result) async {
            String text = result.recognizedWords.toLowerCase();

            print("🎤 HEARD: $text");

            if ((text.contains("help") ||
                    text.contains("save me") ||
                    text.contains("bachao")) &&
                !isTriggered) {

              isTriggered = true;

              print("🚨 EMERGENCY TRIGGERED");

              await EmergencyController.triggerEmergency(context!);

              await Future.delayed(const Duration(seconds: 8));
              isTriggered = false;
            }
          },
        );

        await Future.delayed(const Duration(seconds: 1));

      } catch (e) {
        print("❌ Voice error: $e");
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