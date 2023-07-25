import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pal/secrets.dart';

class OpenAiService {
  var content;
  //to remember convo
  final List<Map<String, String>> messages = [];

  // Future<String> isArtPromptApi(String prompt) async {
  //   try {
  //     final res = await http.post(
  //       Uri.parse("https://api.openai.com/v1/chat/completions"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $apiKey'
  //       },
  //       body: jsonEncode(
  //         {
  //           "model": "gpt-3.5-turbo",
  //           "messages": [
  //             {
  //               "role": "user",
  //               "content":
  //                   "Does this message want to generate an AI picture, art or anything similar? $prompt. Simply answer with a yes or no.",
  //             },
  //           ],
  //         },
  //       ),
  //     );

  //     if (res.statusCode == 200) {
  //       String content =
  //           jsonDecode(res.body)['choices'][0]['message']['content'];
  //       content = content.trim();

  //       switch (content) {
  //         case 'Yes':
  //         case 'yes':
  //         case 'Yes.':
  //         case 'yes.':
  //           final res = await dallEApi(prompt);
  //           return res;
  //         default:
  //           final res = await chatGPTApi(prompt);
  //           return res;
  //       }
  //     }

  //     return "An internal error occured";
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  Future<String> chatGPTApi(String prompt) async {
    //to remeber convo from the initial API call
    // messages.add({
    //   'role': 'user',
    //   'content': prompt,
    // });
    try {
      final res = await http.post(
        Uri.parse('https://simple-chatgpt-api.p.rapidapi.com/ask'),
        headers: {
          'content-type': 'application/json',
          'X-RapidAPI-Key':
              '15104a897cmsh4c08fe94ae48868p1cfa4fjsn9c42dfc5dd0f',
          'X-RapidAPI-Host': 'simple-chatgpt-api.p.rapidapi.com'
        },
        body: jsonEncode(
          {
            'question': prompt,
          },
        ),
      );
      if (res.statusCode == 200) {
        var content = jsonDecode(res.body)['answer'];
        // messages.add({
        //   'role': 'assistant',
        //   'content': content,
        // });
        print(content);
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  // Future<String> dallEApi(String prompt) async {
  //   messages.add({
  //     'role': 'user',
  //     'content': prompt,
  //   });

  //   try {
  //     final res = await http.post(
  //       Uri.parse("https://api.openai.com/v1/images/generations"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $apiKey'
  //       },
  //       body: jsonEncode(
  //         {
  //           "prompt": prompt,
  //           "n": 1,
  //           "size": "1024x1024",
  //         },
  //       ),
  //     );

  //     if (res.statusCode == 200) {
  //       String imgUrl = jsonDecode(res.body)['data'][0]['url'];
  //       imgUrl = imgUrl.trim();
  //       messages.add({
  //         'role': 'assistant',
  //         'content': imgUrl,
  //       });
  //       return imgUrl;
  //     }
  //     return "An internal error occured";
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }
}









// const axios = require('axios');

// const options = {
//   method: 'POST',
//   url: 'https://simple-chatgpt-api.p.rapidapi.com/ask',
//   headers: {
//     'content-type': 'application/json',
//     'X-RapidAPI-Key': '15104a897cmsh4c08fe94ae48868p1cfa4fjsn9c42dfc5dd0f',
//     'X-RapidAPI-Host': 'simple-chatgpt-api.p.rapidapi.com'
//   },
//   data: {
//     question: 'what is javascript?'
//   }
// };

// try {
// 	const response = await axios.request(options);
// 	console.log(response.data);
// } catch (error) {
// 	console.error(error);
// }




// fetch('https://jsonplaceholder.typicode.com/posts', {
//   method: 'POST',
//   body: JSON.stringify({
//     title: 'foo',
//     body: 'bar',
//     userId: 1,
//   }),
//   headers: {
//     'Content-type': 'application/json; charset=UTF-8',
//   },
// })
//   .then((response) => response.json())
//   .then((json) => console.log(json));