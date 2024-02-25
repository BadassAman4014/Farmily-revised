import 'package:flutter/material.dart';
import 'default_login_page.dart';

class Language {
  final String name;
  final String flagPath;

  Language({required this.name, required this.flagPath});
}

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LanguageSelectionPage(),
    );
  }
}

class LanguageSelectionPage extends StatefulWidget {
  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  Language? selectedLanguage;

  final List<Language> languages = [
    Language(name: 'English', flagPath: 'assets/flags/usa.png'),
    Language(name: 'Hindi', flagPath: 'assets/flags/India.png'),
    Language(name: 'Marathi', flagPath: 'assets/flags/India.png'),
    Language(name: 'Telugu', flagPath: 'assets/flags/India.png'),
    Language(name: 'French', flagPath: 'assets/flags/france.png'),
    Language(name: 'African', flagPath: 'assets/flags/south_africa.png'),
    Language(name: 'Javanese', flagPath: 'assets/flags/indonesia.png'),
    Language(name: 'Mandarin', flagPath: 'assets/flags/china.png'),
    Language(name: 'Spanish', flagPath: 'assets/flags/Spain.png'),
  ];

  void _showSelectedLanguageDialog(Language language) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Selected Language: ${language.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                language.flagPath,
                height: 50.0,
                width: 50.0,
              ),
              SizedBox(height: 10.0),
              Text(
                'This is the language you selected!',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the signup page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              child: Text(
                'Continue to Sign Up',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose the Language'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: languages
                .map(
                  (language) => LanguageTile(
                language: language,
                isSelected: selectedLanguage == language,
                onTap: () {
                  setState(() {
                    selectedLanguage = language;
                  });
                  // Add functionality when a language is selected
                  print('Selected language: ${language.name}');
                  // Show the selected language dialog
                  _showSelectedLanguageDialog(language);
                },
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    Key? key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Image.asset(
              language.flagPath,
              height: 30.0,
              width: 30.0,
            ),
            SizedBox(width: 16.0),
            Text(
              language.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}
