import 'dart:convert';

class Restaurant {
  final String name;
  final String category;
  final String description;
  final String address;
  final String city;
  final String postcode;
  final String lat;
  final String lng;
  final List<String> working_hours;
  final List<String> images;
  final String phone;
  final String email;
  final String website;
  final String facebook;
  final String instagram;
  final String tiktok;




  // Add more fields as needed

  Restaurant({
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.city,
    required this.postcode,
    required this.lat,
    required this.lng,
    required this.images,
    required this.working_hours,
    required this.phone,
    required this.email,
    required this.website,
    required this.facebook,
    required this.instagram,
    required this.tiktok,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      lat: json['latitude'].toString(),
      lng: json['longitude'].toString(),
      images: List<String>.from(json['images'] ?? []),


      working_hours: List<String>.from(jsonDecode(json['working_hours'] ?? '[]')),
      //working_hours: List<String>.from(jsonDecode(json['working_hours'] ?? '[]')),
      //working_hours: List<String>.from(json['working_hours'] ?? []),

      //working_hours: json['working_hours'] ?? '', // optional

      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      tiktok: json['tiktok'] ?? '',


    );
  }

  Map<String, dynamic> toMap() {
    return {

      'name': name,
      'category': category,
      'description': description,
      'address': address,
      'city': city,
      'postcode': postcode,
      'lat': lat,
      'lng': lng,
      'images': images, // ✅ List<String>
      'working_hours': working_hours,
      'phone': phone,
      'email': email,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'tiktok': tiktok,
    };


  }
}
