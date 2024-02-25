import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiAPIinApp {
  //create a header
  static Future<Map<String, String>> getHeader() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  //now lets create a http request
  static Future<String> getGeminiData(message) async {
    try {
      String apiKey1 = 'AIzaSyDUB7kfOrbDG1sfmdz9haZ7aofjFdOf0JU'; // farmily bot
      String apiKey2 = 'AIzaSyCEjZtiQq19bAgfR09xuIE37qYK7DJbEXg'; //InApp support bot
      final header = await getHeader();

      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': message,
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.8, // it may vary from 0 to 1
          'maxOutputTokens': 1000 //its the max tokens to generate result
        }
      };

      String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey2';

      var response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(requestBody),
      );

      print(response.body); //to fix if theres any error check logs

      if (response.statusCode == 200) {
        //200 for success response
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        //this returns the result generated by gemini
      } else {
        return '';
      }
    } catch (e) {
      print("Error: $e");
      return '';
    }
  }
}
