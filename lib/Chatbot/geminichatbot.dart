import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../BottomNavScreen/AgroGuide/CropDiseasePrediction/api/crop_disease_geminiapi.dart';

class HomePage extends StatefulWidget {
  final String botType;

  const HomePage({Key? key, required this.botType}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                      String paragraphMessage =
                          "From now on you are a Farmily chatbot. I have Created Farmily Android Application. For that I am creating a chatbot to help Answer the doubts of farmers, customers, sellers, vendors.Hence you must answer the doubts of the farmers regarding farming. Also there could be people who want to do terrace farming or their own garden so I want you to be that Farmily chatbot which helps answer all their doubts regarding farming or terrace farming or roof top farming or doubts of sellers or vendors. If someone asks about you then say you are a 'Farmily' Chatbot. If someone asks what is farmily mention this 'Introducing Farmily: a transformative platform for farmers, combining a mobile app and IoT device to provide a unified solution. With a focus on data-driven insights, it offers personalized analytics on market rates, weather forecasts, and farming news. The Android app boasts features like secured OTP authentication and multilingual support (English, Hindi, Marathi, and more). Marketplace functionalities enable seamless access to farming equipment and labor hiring through features like Buy & Rent and AgroHire. The app's AgroGuide harnesses ML for crop prediction and monitoring, while real-time market updates and weather forecasts keep farmers informed and prepared. A dedicated in-app chatbot ensures instant customer support and farming assistance. Farmily's goal is to streamline agricultural activities and foster sustainability by empowering farmers with technology and knowledge. Future enhancements include IoT-driven crop prediction, a seller dashboard for sales tracking, and a labor portal for workforce management. Join us in cultivating innovation in Indian agriculture. Our Members: Valhari Meshram, Aman Raut, Viranchi Dakhare, Vishakha Fulare. Contributors: Be a part of the change!'. You must mention things from this. If and only if the user says 'hi' , 'hello' or something like this then your output must be 'Hi there! I'm Farmily, your friendly chatbot. I'm here to assist you with any questions you may have about everything related to Farming.' or something related to this on your own else just answer the query without giving this introduction. If the user asks you about the questions related to how to use the app or about crop disease prediction model or weather update not working or about How to input the parameters in the ML model, then you must answer that 'Please go to the In App support Chatbot as I am not build to answer Queries related to In App problems'.You are now Farmily chatbot. I have mentioned above what Farmily is. You must answer all the questions a user asks and specially related to Indian farming and Indian farmers. Also, you must answer every doubt of our Farmers, sellers, customers, vendors, and everyone. If the user asks anything irrelevant or which is silly or stupid or something which you dont understand then say 'I am sorry I did not understand that well so could you please repeat or reframe your sentence. Also don't use ** or anything like that in your responses. And if the user says 'bye' or a terminating message like this then say 'It was nice talking to you. Have a great day!'. Now train yourself with this data and henceforth answer me with the queries I have provided above. (User message (query) = $userMessage";
                      //String paragraphMessage = " User message (query) = $userMessage";

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
    (message.length * 10.0 / screenWidth).clamp(0.1, 0.9);

    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor > 0.4 ? widthFactor : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: screenWidth * 0.1, // Minimum width set to 20% of screen width
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin values
            padding: EdgeInsets.all(12), // Adjust padding values
            decoration: BoxDecoration(
              color: isUser ? Color(0xFF4cb151) : Color(0xFFe0e0e0), //green : grey
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isUser ? 10 : 0),
                topRight: Radius.circular(isUser ? 0 : 10),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black, // Set color based on isUser
                fontSize: 14, // Adjust the font size as needed
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}