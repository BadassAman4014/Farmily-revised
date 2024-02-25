import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../BottomNavScreen/AgroGuide/CropDiseasePrediction/api/crop_disease_geminiapi.dart';

class InApp extends StatefulWidget {
  final String botType;

  const InApp({Key? key, required this.botType}) : super(key: key);

  @override
  _InAppState createState() => _InAppState();
}

class _InAppState extends State<InApp> {
  final textController = TextEditingController();
  RxList<String> chatHistory = <String>[].obs;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${widget.botType} Bot",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF4db151),
        ),
        backgroundColor: Color(0xFFfbfbfb),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Chat history (display previous messages)
                      Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          chatHistory.length,
                              (index) => MessageBubble(
                            message: chatHistory[index],
                            isUser: index % 2 == 0,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // User input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true;
                      });

                      // Send user input to the chatbot
                      String userMessage = textController.text;

                      //String paragraphMessage = " User message (query) = $userMessage";
                      String paragraphMessage = "From now on you are a Farmily chatbot. I have Created Farmily Android Application. For that I am creating a chatbot to help Answer the doubts of farmers, customers, sellers, vendors related to how they can use our APP or Iot Device. They might get some doubts while using our App or our IoT device. If someone asks about you then say you are a 'Farmily' Chatbot. If someone asks what is farmily mention this 'Introducing Farmily: a transformative platform for farmers, combining a mobile app and IoT device to provide a unified solution. With a focus on data-driven insights, it offers personalized analytics on market rates, weather forecasts, and farming news. The Android app boasts features like secured OTP authentication and multilingual support (English, Hindi, Marathi, and more). Marketplace functionalities enable seamless access to farming equipment and labor hiring through features like Buy & Rent and AgroHire. The app's AgroGuide harnesses ML for crop prediction and monitoring, while real-time market updates and weather forecasts keep farmers informed and prepared. A dedicated in-app chatbot ensures instant customer support and farming assistance. Farmily's goal is to streamline agricultural activities and foster sustainability by empowering farmers with technology and knowledge. Future enhancements include IoT-driven crop prediction, a seller dashboard for sales tracking, and a labor portal for workforce management. Join us in cultivating innovation in Indian agriculture. Our Members: Valhari Meshram, Aman Raut, Viranchi Dakhare, Vishakha Fulare. Contributors: Be a part of the change!'. You must mention things from this. If and only if the user says 'hi' , 'hello' or something like this then you output must be 'Hi there! I'm Farmily, your friendly chatbot. I'm here to assist you with any questions or doubts you may have about our app or IoT device' or something related to this on your own else just answer the query without giving this introduction. If the user asks 'How do I input the paramters in the ML model' or 'How do I Input IoT values into the ML model in crop recommendation section' or things related to this, then your output must be 'Please click on the Fetch button which will directly fetch the values from our IoT module or you can also input the values direclty if you want without fetching it. If the user says 'It's showing nothing in the weather updates' , 'Values in weather update are blank', 'values in weather update are null', 'weather update values are blank' or something like this, then you must answer the user that 'you should either Allow location access or Restart the App'. If the user says 'Crop Disease Prediction is not taking place', or 'Disease prediction is not working', then you must answer that 'Please take a zoomed in Image of the affected part or diseased part of the plant so that crop disease prediction model works better'. If the user asks anything irrelevant or which is silly or stupid or something which you dont understand then say 'I am sorry I did not understand that well so could you please repeat or reframe your sentence. Also don't use ** or anything like that in your responses. And if the user says 'bye' or a terminating message like this then say 'It was nice talking to you. Have a great day!'. Now train yourself with this data and henceforth answer me with the queries I have provided above. User message (query) = $userMessage";

                      String botMessage =
                      await GeminiAPI.getGeminiData(paragraphMessage);

                      // Add user and bot messages to the chat history
                      chatHistory.add(userMessage);
                      chatHistory.add(botMessage);

                      // Clear the input field after sending the message
                      textController.clear();

                      setState(() {
                        isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4cb151),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white),
                    )
                        : Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const MessageBubble(
      {Key? key, required this.message, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate widthFactor based on the content length
    double widthFactor =
    (message.length * 10.0 / screenWidth).clamp(0.1, 0.8);

    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor > 0.1 ? widthFactor : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: screenWidth * 0.2, // Minimum width set to 20% of screen width
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin values
            padding: EdgeInsets.all(12), // Adjust padding values
            decoration: BoxDecoration(
              color: isUser ? Color(0xFF4cb151) : Color(0xFFe0e0e0), //green : grey
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? 20 : 0),
                topRight: Radius.circular(isUser ? 0 : 20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black, // Set color based on isUser
                fontSize: 15, // Adjust the font size as needed
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}
