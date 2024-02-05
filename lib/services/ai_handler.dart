import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AIHandler {
 //late final request;
  final _openAI = OpenAI.instance.build(
    token: 'sk-PlblAHnPZmk4WaN54IUaT3BlbkFJCZDqzNkVq7QsdcaaqA1qq',
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
    enableLog: true,
  );

  Future<String> getResponse(String msg) async {
    try {
     final request = ChatCompleteText(
        messages: [
          Messages(role: Role.assistant, content: msg),
        ],
        maxToken: 200,
        model: GptTurbo0631Model(),
      );

      final response = await _openAI.onChatCompletion(request: request);

      if (response != null && response is ChatCTResponse) {
        // Check if there are choices and if the first choice has a message
        if (response.choices.isNotEmpty && response.choices[0].message != null) {
          return response.choices[0].message!.content.trim();
        }
      }

      return 'Something went wrong!';
    } catch (e) {
      return 'Bad Response';
    }
  }

  void dispose() {

    mCancel?.cancelToken.cancel("canceled");
  }

  CancelData? mCancel;

  void onCancel(CancelData cancelData) {
    mCancel = cancelData;
  }
}
