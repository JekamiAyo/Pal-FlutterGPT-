import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pal/secrets.dart';

class OpenAiService {
  //to remember convo
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptApi(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, art or anything similar? $prompt. Simply answer with a yes or no.",
              },
            ],
          },
        ),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEApi(prompt);
            return res;
          default:
            final res = await chatGPTApi(prompt);
            return res;
        }
      }

      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTApi(String prompt) async {
    //to remeber convo from the initial API call
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": messages,
          },
        ),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEApi(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });

    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/images/generations"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
        body: jsonEncode(
          {
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024",
          },
        ),
      );

      if (res.statusCode == 200) {
        String imgUrl = jsonDecode(res.body)['data'][0]['url'];
        imgUrl = imgUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imgUrl,
        });
        return imgUrl;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }
}
