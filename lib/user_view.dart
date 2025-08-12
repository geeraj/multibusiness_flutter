import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shan_exercise3/homepage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shan_exercise3/model_restaurant.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(UserApp());
}

class UserApp extends StatefulWidget {
  @override
  _UserAppState createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User View',

      theme: _royalBlueTheme(),
      debugShowCheckedModeBanner: false,
      home: ShopHomePage(),
    );
  }

  ThemeData _royalBlueTheme() => ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white, // ← changed from royal blue
      foregroundColor: Colors.black, // ← text/icon color
      elevation: 1,
    ),
    cardColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black),
      prefixIconColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0861B5),
      ),
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
  );
}

class ShopHomePage extends StatefulWidget {
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  final logger = Logger();
  TextEditingController searchController = TextEditingController();
  Set<String> favorites = {};
  late final PageController _bannerController;
  //late final List<String> _bannerItems;
  late final List<Map<String, String>> _bannerItems;
  int _currentBanner = 0;
  Timer? _bannerTimer;

  /*List<Map<String, String>> allRestaurants = [
    {
      'name': 'Spicy Villa',
      'category': 'Restaurant',
      'description' : "good restaurant",
      'postcode': '12345',
      'address': '12 Elm Street',
      'location': 'Downtown',
      'image': 'assets/spicy_villa.png',
      'lat': '37.7749',
      'lng': '-122.4194',
      'workingHours': '''
    Mon: 9:00 AM – 10:00 PM
    Tue: 9:00 AM – 10:00 PM
    Wed: 9:00 AM – 10:00 PM
    Thu: 9:00 AM – 10:00 PM
    Fri: 9:00 AM – 11:00 PM
    Sat: 10:00 AM – 11:00 PM
    Sun: Closed
    ''',
      'phone': '+60123456789',
      'email': 'info@tastyspoon.com',
      'website': 'https://tastyspoon.com',
      'facebook': 'https://facebook.com/tastyspoon',
      'instagram': 'https://instagram.com/tastyspoon',
      'tiktok': 'https://www.tiktok.com/0123456789'
    },


  ];*/

  List<Map<String, dynamic>> filteredRestaurants = [];
  List<Map<String, dynamic>> allRestaurants = [];

  Future<void> loadRestaurants() async {
    List<Restaurant> restaurantList = await fetchRestaurants();

    setState(() {
      //allRestaurants = restaurantList.map((r) => r.toMap()).toList();
      allRestaurants = restaurantList.map((r) => r.toMap()).toList();

      filteredRestaurants = allRestaurants;
    });

    logger.i('We received all the restaurant data');
    logger.i (allRestaurants);

    //print('We received all the restaurant data');
    //print(allRestaurants); // You’ll now see updated values
  }



  Future<List<Restaurant>> fetchRestaurants() async {
    final logger = Logger();
    print('before checking');

    final response = await http.get(
      //Uri.parse('http://192.168.0.102:8001/api/restaurants'), // Your PC's IP
      Uri.parse('http://multibusiness.velluvom.com/api/restaurants'),
      headers: {'Accept': 'application/json'},
    );

    print(response.statusCode);

    if (response.statusCode == 200) {

      List jsonData = jsonDecode(response.body);


      print('[info] We have received jsonData');
      print(jsonData);
      print(jsonData[0]['images']);
      print(jsonData[0]['images'].runtimeType);

      logger.i('[info] We have received jsonData');
      logger.i(jsonData);
      //logger.i(jsonData[0]['images']);
      //logger.i(jsonData[0]['images'].runtimeType);



      return jsonData.map((item) => Restaurant.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }




  @override
  void initState() {
    super.initState();
    loadRestaurants();

    print("Total item for the list is ::: " );
    print(filteredRestaurants.length);

    _bannerItems = [
      {
        'image': 'assets/banner1.png',
        'url': 'https://www.velluvom.com/',
      },
      {
        'image': 'assets/banner2.png',
        'url': 'https://www.velluvom.com/',
      },
      {
        'image': 'assets/banner3.png',
        'url': 'https://www.velluvom.com/',
      },
    ];



    _bannerController = PageController(viewportFraction: 0.9);

    _bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentBanner < _bannerItems.length - 1) {
        _currentBanner++;
      } else {
        _currentBanner = 0;
      }
      _bannerController.animateToPage(
        _currentBanner,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();
      filteredRestaurants = allRestaurants.where((restaurant) {
        return restaurant['postcode']!.contains(query) ||
            restaurant['name']!.toLowerCase().contains(lowerQuery) ||
            restaurant['city']!.toLowerCase().contains(lowerQuery) ||
            restaurant['category']!.toLowerCase().contains(lowerQuery) ||
            restaurant['description']!.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (favorites.contains(name)) {
        favorites.remove(name);
      } else {
        favorites.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(filteredRestaurants.length);
    return Scaffold(
      appBar: AppBar(title: Text("User View"),
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
          // Logo Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/velluvom.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),

          // Image Banner Carousel
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 5.0),
            child: SizedBox(
              height: 160,
              child: PageView(
                controller: _bannerController,
                children: _bannerItems.map((item) {
                  final imagePath = item['image']!;
                  final url = item['url']!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch URL')),
                          );
                        }
                      },


                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(imagePath, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),



          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0861B5),
                    Color(0xFF0B74D4), // Lighter or second tone of blue
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: _search,
                      decoration: InputDecoration(
                        labelText: 'Search by Name, Postcode or Location',
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(

                      itemCount: filteredRestaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = filteredRestaurants[index];


                        final List<dynamic> imageUrls = restaurant['images'] ?? [];
                        final String? imageUrl = imageUrls.isNotEmpty ? imageUrls[0] : null;

                        final isFav = favorites.contains(restaurant['name']);

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:

                             Image.network(imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,),

                              /*Image.asset(
                                'assets/velluvom.png',
                                height: 40,
                                fit: BoxFit.contain,
                              ),*/

                            ),
                           title:
                              Text(
                              restaurant['name']!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${restaurant['category']}.${restaurant['address']} • ${restaurant['city']}',
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleFavorite(restaurant['name']!),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailPage(
                                    restaurant: restaurant,
                                    isFavorite: isFav,
                                    onFavoriteToggle: () => _toggleFavorite(restaurant['name']!),
                                  ),
                                ),
                              );
                            },
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

class RestaurantDetailPage extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  RestaurantDetailPage({
    required this.restaurant,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    double lat = double.parse(restaurant['lat']);

    print('Restaurant: ${restaurant['name']}');
    double lng = double.parse(restaurant['lng']);
    LatLng position = LatLng(lat, lng);
    final List<dynamic> imageUrls = restaurant['images'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['name']!),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: onFavoriteToggle,
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount:imageUrls.length-1,
                itemBuilder: (context, index) {
                  final imagePath=imageUrls[index + 1];
                  //final imagePath = 'assets/images/${index + 1}.jpg';
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: //Image.asset(imagePath, fit: BoxFit.contain),

                            Image.network(imagePath, fit: BoxFit.contain,),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: //Image.asset(imagePath, fit: BoxFit.cover),
                          Image.network(imagePath, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
          ),

          Container(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              markers: {
                Marker(
                  markerId: MarkerId('restaurant'),
                  position: position,
                  infoWindow: InfoWindow(title: restaurant['name']),
                )
              },
            ),
          ),

          // Restaurant Details with Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0861B5), Color(0xFF2A8DDF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant['name']!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),


                SizedBox(height: 12),
                Divider(color: Colors.white70),

                // Address
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.white),
                  title: Text('Address', style: TextStyle(color: Colors.white)),
                  subtitle: Text(restaurant['address']!, style: TextStyle(color: Colors.white70)),
                ),
                Divider(color: Colors.white30, height: 0),

                // Location
                ListTile(
                  leading: Icon(Icons.map, color: Colors.white),
                  title: Text('Location', style: TextStyle(color: Colors.white)),
                  subtitle: Text(restaurant['city']!, style: TextStyle(color: Colors.white70)),
                ),

                Divider(color: Colors.white30, height: 0),

                // Postcode
                ListTile(
                  leading: Icon(Icons.markunread_mailbox, color: Colors.white),
                  title: Text('Postcode', style: TextStyle(color: Colors.white)),
                  subtitle: Text(restaurant['postcode']!, style: TextStyle(color: Colors.white70)),
                ),

                SizedBox(height: 16),

                // Working Hours
               /*ExpansionTile(
                  leading: Icon(Icons.access_time, color: Colors.white),
                  title: Text('Working Hours', style: TextStyle(color: Colors.white)),
                  children: restaurant['working_hours']!
                      .split('\n')
                      .map((line) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(line, style: TextStyle(color: Colors.white70)),
                    ),
                  ))
                      .toList(),
                ),*/

                ExpansionTile(
                  leading: Icon(Icons.access_time, color: Colors.white),
                  title: Text('Working Hours', style: TextStyle(color: Colors.white)),
                  children: (restaurant['working_hours'] as List<dynamic>)
                      .map((line) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(line.toString(), style: TextStyle(color: Colors.white70)),
                    ),
                  ))
                      .toList(),
                ),

                // Description
                Divider(color: Colors.white30),
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.white),
                  title: Text('Description', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    restaurant['description'] ?? 'No description available',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                // Contact Number
                Divider(color: Colors.white30),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.white),
                  title: Text('Contact Number', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    restaurant['phone'] ?? 'Not available',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                // Instagram
                Divider(color: Colors.white30),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.white),
                  title: Text('Instagram', style: TextStyle(color: Colors.white)),
                  subtitle: GestureDetector(
                    onTap: () async {
                      final url = restaurant['instagram'] ?? '';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(
                      restaurant['instagram'] ?? 'Not available',
                      style: TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline),
                    ),
                  ),
                ),

                // Facebook
                Divider(color: Colors.white30),
                ListTile(
                  leading: Icon(Icons.facebook, color: Colors.white),
                  title: Text('Facebook', style: TextStyle(color: Colors.white)),
                  subtitle: GestureDetector(
                    onTap: () async {
                      final url = restaurant['facebook'] ?? '';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(
                      restaurant['facebook'] ?? 'Not available',
                      style: TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline),
                    ),
                  ),
                ),

                // TikTok
                Divider(color: Colors.white30),
                ListTile(
                  leading: Icon(Icons.video_collection, color: Colors.white),
                  title: Text('TikTok', style: TextStyle(color: Colors.white)),
                  subtitle: GestureDetector(
                    onTap: () async {
                      final url = restaurant['tiktok'] ?? '';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(
                      restaurant['tiktok'] ?? 'Not available',
                      style: TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline),
                    ),
                  ),
                ),

                // Website
                Divider(color: Colors.white30),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.white),
                  title: Text('Website', style: TextStyle(color: Colors.white)),
                  subtitle: GestureDetector(
                    onTap: () async {
                      final url = restaurant['website'] ?? '';
                      if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Website link is not available')),
                        );
                      }
                    },
                    child: Text(
                      restaurant['website'] ?? 'Not available',
                      style: TextStyle(color: Colors.lightBlueAccent, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0861B5),
                  ),
                  icon: Icon(Icons.navigation),
                  label: Text("Open in Google Maps"),
                  onPressed: () async {
                    final uri = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Could not launch Maps")),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



