import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';

class ChatGPTRepository {
  Future<String> promptMessage(String prompt) async {
    try {
      const url = "https://api.openai.com/v1/completions";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.getOpenAPIKey}',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'temperature': 0,
          'max_tokens': 1000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['text'];
      } else {
        return "Ocorreu um erro";
      }
    } catch (e) {
      return "Ocorreu um erro";
    }
  }
}
