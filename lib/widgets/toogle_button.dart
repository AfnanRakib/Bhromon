import 'package:bhromon/widgets/text_and_voice_field.dart';
import 'package:flutter/material.dart';
class ToggleButton extends StatefulWidget {
  final VoidCallback _sendTextMessage;
  final VoidCallback _sendVoiceMessage;
  final InputMode _inputMode;
  final bool _isListening ;
  const ToggleButton({super.key,required InputMode inputMode,
    required VoidCallback sendTextMessage,
    required VoidCallback sendVoiceMessage,
    required bool isListening
  })
      : _inputMode = inputMode,
      _sendTextMessage = sendTextMessage,
      _sendVoiceMessage = sendVoiceMessage,
      _isListening = isListening;

  @override
  State<ToggleButton> createState() => _TogleButtonState();
}

class _TogleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            shape: const CircleBorder(),
            padding: EdgeInsets.all(15)
        ),
        onPressed: widget._inputMode == InputMode.text
            ? widget._sendTextMessage
            : widget._sendVoiceMessage,
        child: Icon(widget._inputMode == InputMode.text
            ? Icons.send
            :widget._isListening ?Icons.mic_off : Icons.mic));
  }
}
