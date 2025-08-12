import 'package:flutter/material.dart';
import 'package:shan_exercise3/homepage.dart';

void main() {
  runApp(AnnouncementApp());
}

class AnnouncementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Owner View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      home: AnnouncementHomePage(),
    );
  }
}

class AnnouncementHomePage extends StatelessWidget {
  final List<String> sliderImages = [
    'assets/announcement1.jpg',
    'assets/announcement2.jpg',
    'assets/announcement3.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text("Announcement View"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          ),
        ),
      ),
      body: Column(
        children: [
          // White background logo section
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/velluvom.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),

          // Gradient section starts after logo
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0861B5),
                    Color(0xFF0B74D4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: PageView.builder(
                      itemCount: sliderImages.length,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              sliderImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),



    );
  }
}
