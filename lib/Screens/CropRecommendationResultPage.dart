import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResultPage extends StatelessWidget {
  final String result;
  final String predictedCrop;

  ResultPage({required this.result, required this.predictedCrop});

  List<Widget> parseAndGenerateWidgets(String text) {
    List<Widget> widgets = [];

    // Split the text by '**' to find headings
    List<String> parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      // Alternate parts will be the headings, others will be content
      if (i.isOdd) {
        // Remove indexing numbers from the heading
        String headingWithoutIndex = parts[i].replaceAll(RegExp(r'^\d+\. '), '');
        // Remove excess asterisks from the heading
        String headingWithoutAsterisks = headingWithoutIndex.replaceAll(RegExp(r'\*+'), '');

        String content = (i + 1 < parts.length) ? parts[i + 1] : '';

        // Check if content is not empty before adding the combined widget
        if (content.trim().isNotEmpty) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 3, // Add elevation for a card-like appearance
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Set the overall border radius
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color for the white box
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius for the white box
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center alignment
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF003032), // Set the background color for the blue box
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0), // Set the top-left border radius for the blue box
                            bottomRight: Radius.circular(12.0), // Set the top-right border radius for the blue box
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0), // Adjust padding for left and right extension
                        child: Text(
                          headingWithoutAsterisks,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        content,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    return widgets;
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = parseAndGenerateWidgets(result);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Predicted Crop',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF003032),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF003032), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center alignment
            crossAxisAlignment: CrossAxisAlignment.center, // Center alignment
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center, // Center alignment
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/farm.jpg',
                        height: 200.0,
                        width: 400.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          "$predictedCrop",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Use the widgets generated from parsing the result
              ...widgets,
              SizedBox(height: 5),
              Container(
                alignment: Alignment.center, // Center alignment
                child: ElevatedButton(
                  onPressed: () {
                    // Open a web view to render the website link
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(url: 'https://www.india.gov.in/topics/agriculture'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF003032), // Set the background color
                    // Adjust padding as needed
                  ),
                  child: Text(
                    'More Info',
                    style: TextStyle(
                      color: Colors.white, // Change the text color
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Info'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
