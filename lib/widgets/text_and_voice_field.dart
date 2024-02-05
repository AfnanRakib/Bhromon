import 'dart:convert';
import 'package:bhromon/model/chat_mode.dart';
import 'package:bhromon/provider/chats_provider.dart';
import 'package:bhromon/services/ai_handler.dart';
import 'package:bhromon/services/voice_handler.dart';
import 'package:bhromon/widgets/toogle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({Key? key}) : super(key: key);

  @override
  ConsumerState<TextAndVoiceField> createState() =>
      _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final AIHandler _openAI = AIHandler();
  final VoiceHandler voiceHandler = VoiceHandler();
  FlutterTts flutterTts = FlutterTts();
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;


  var _isListening = false;

  @override
  void initState() {
    super.initState();
    voiceHandler.initSpeech();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _openAI.dispose();
    //tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputMode(InputMode.text)
                  : setInputMode(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        ToggleButton(
          isListening: _isListening,
          inputMode: _inputMode,
          sendTextMessage: () {
            final message = _messageController.text;
            _messageController.clear();
            sendTextMessage(message);
          },
          sendVoiceMessage: sendVoiceMessage,
        )
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  Future<void> sendVoiceMessage() async {
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      final result = await voiceHandler.startListening();
      setListeningState(false);
      sendTextMessage(result);
    }
  }

  void sendTextMessage(String msg) async {
    addToList(msg, true, DateTime.now().toString());
    final aiResponse = await _openAI.getResponse(msg);
    addToList(
      aiResponse,
      false,
      DateTime.now().toString(),
    );

    speak(aiResponse);
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void addToList(String message, bool isMe, String id) {
    final chats = ref.read(chatsProvider.notifier);
    chats.add(
      ChatModel(
        id: id,
        message: message,
        isMe: isMe,
      ),
    );
  }
  Future<void> speak(String message) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (message.isNotEmpty) {
      await flutterTts.speak(message);
    }
  }

}