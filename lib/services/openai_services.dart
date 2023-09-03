import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAiService {
  var content;

  Future<String> chatGPTApi() async {
    try {
      final res = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'title': 'foo',
            'body': 'bar',
            'userId': 1,
          },
        ),
      );
      if (res.statusCode == 200) {
        var content = jsonDecode(res.body)['answer'];
        print(content);
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }
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