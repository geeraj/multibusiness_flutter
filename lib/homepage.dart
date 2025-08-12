import 'package:flutter/material.dart';
import 'package:shan_exercise3/user_view.dart';
import 'package:shan_exercise3/owner_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shan_exercise3/announcements.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color royalBlue = Color(0xFF0861B5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Role-Based Restaurant App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: royalBlue,
        scaffoldBackgroundColor: royalBlue,
        appBarTheme: AppBarTheme(
          backgroundColor: royalBlue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: royalBlue,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardColor: Colors.white,
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Logo Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, top: 20),
                      child: Image.asset(
                        'assets/velluvom.png',
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Body
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0861B5), Color(0xFF3B8BEA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.restaurant_menu, size: 48, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Choose your view',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 20),

                    // Example Role Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RoleCard(
                        title: 'Owner View',
                        description: 'Register and manage your restaurant.',
                        icon: Icons.storefront,
                        color: Colors.white,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => OwnerHomePage()),
                        ), // Replace with navigation
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RoleCard(
                        title: 'User View',
                        description: 'Browse and discover restaurants.',
                        icon: Icons.person_outline,
                        color: Colors.white,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => UserApp()),
                        ), // Replace with navigation
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RoleCard(
                        title: 'Announcement',
                        description: 'View latest news and updates.',
                        icon: Icons.announcement_outlined,
                        color: Colors.white,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => AnnouncementApp()),
                        ),// Replace with navigation
                      ),
                    ),

                    SizedBox(height: 135),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        children: [

                          Text(
                            'Contact Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          GestureDetector(
                            onTap: () async {
                              final phoneNumber = '60136268080';
                              final whatsappUri = Uri.parse('https://wa.me/$phoneNumber');
                              if (await canLaunchUrl(whatsappUri)) {
                                await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch WhatsApp';
                              }
                            },


                            child: Text(
                              'Admin | WhatsApp 0136268080',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final Uri webUri = Uri.parse('https://www.velluvom.com');
                              if (await canLaunchUrl(webUri)) {
                                await launchUrl(webUri, mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch $webUri';
                              }
                            },
                            child: Text(
                              'www.velluvom.com',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: Duration(milliseconds: 100),
      scale: _pressed ? 0.97 : 1.0,
      child: Card(
        elevation: 4,
        color: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Icon(widget.icon, size: 32, color: Color(0xFF4169E1)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Color(0xFF4169E1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
