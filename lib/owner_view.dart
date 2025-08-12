import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shan_exercise3/homepage.dart';

import 'homepage.dart'; // Make sure this exists

void main() {
  runApp(OwnerApp());
}

class OwnerApp extends StatelessWidget {
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
      home: OwnerHomePage(),
    );
  }
}

class OwnerHomePage extends StatefulWidget {
  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  final _formKey = GlobalKey<FormState>();

  List<XFile> selectedImages = [];
  List<XFile> selectedImagesProfile = [];
  List<String> uploadedImagePaths = [];
  //bool isUploading = false;
  //bool isUploadingProfile = false;
  final List<XFile>? pickedFiles = [];
  bool isSubmitting = false;

  String name = '';
  String category = '';
  String description = '';
  String address = '';
  String city = '';
  String postcode = '';
  String latitude = '';
  String longitude = '';

  String phone = '';
  String email = '';
  String website = '';
  String facebook = '';
  String instagram = '';
  String tiktok = '';



  /*final TextEditingController nameController = TextEditingController(text: "name");
  final TextEditingController descriptionController = TextEditingController(text: "name");
  final TextEditingController addressController = TextEditingController(text: "name");
  final TextEditingController longitudeController = TextEditingController(text: "10");
  final TextEditingController cityController = TextEditingController(text: "name");
  final TextEditingController postcodeController = TextEditingController(text: "name");
  final TextEditingController latitudeController = TextEditingController(text: "10");

  final TextEditingController phoneController = TextEditingController(text: "name");
  final TextEditingController emailController = TextEditingController(text: "name");
  final TextEditingController websiteController = TextEditingController(text: "name");
  final TextEditingController facebookController = TextEditingController(text: "name");
  final TextEditingController instagramController = TextEditingController(text: "name");
  final TextEditingController tiktokController = TextEditingController(text: "name");*/

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();


  final Map<String, TimeOfDay?> startTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  final Map<String, TimeOfDay?> endTimes = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
    'Sunday': null,
  };

  Future<void> pickTime(BuildContext context, String day, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTimes[day] = picked;
        } else {
          endTimes[day] = picked;
        }
      });
    }
  }

  String formatTimeManual(TimeOfDay? time) {
    if (time == null) return "--";
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }



  /*Future<void> pickAndUploadImages(BuildContext context) async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles == null || pickedFiles.isEmpty) {
      print("No images selected.");
      return;
    }

    if (pickedFiles.length > 20) {
      print("You can select up to 20 images only.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can select up to 20 images only.")),
      );
      return;
    }

    setState(() {

      selectedImages = pickedFiles;
      //isUploading = true;
      uploadedImagePaths.clear();
    });

  }*/

  Future<void> pickAndUploadImages(BuildContext context) async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles == null || pickedFiles.isEmpty) {
      print("No images selected.");
      return;
    }

    // Combine old + new
    List<XFile> combined = List.from(selectedImages);

    // Add only new images that aren't duplicates
    for (var file in pickedFiles) {
      if (!combined.any((existing) => existing.path == file.path)) {
        combined.add(file);
      }
    }

    // Limit to 20 max
    if (combined.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Only first 20 images are kept.")),
      );
      combined = combined.sublist(0, 20);
    }

    setState(() {
      selectedImages = combined;
      uploadedImagePaths.clear();
    });
  }

  Future<void> pickAndUploadProfile(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print("No image selected.");
      return;
    }

    setState(() {
      selectedImagesProfile = [pickedFile]; // store as list for consistency
      uploadedImagePaths.clear();
    });
  }



  /*Future<void> pickAndUploadProfile(BuildContext context) async {
      final picker = ImagePicker();
      final List<XFile>? pickedFilesProfile = await picker.pickMultiImage();

      if (pickedFilesProfile == null || pickedFilesProfile.isEmpty) {
        print("No images selected.");
        return;
      }

      if (pickedFilesProfile.length > 1) {
        print("You can select only one image.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can select only one image. ")),
        );
        return;
      }

    setState(() {
      selectedImagesProfile = pickedFilesProfile;

      //isUploadingProfile = true;
      uploadedImagePaths.clear();
    });

  }*/



  Future<bool> submitRestaurant() async {
    int imageCount=0;

    try {
      final name = nameController.text;
      final description = descriptionController.text;
      final address = addressController.text;
      final longitude = longitudeController.text;
      final city = cityController.text;
      final postcode = postcodeController.text;
      final latitude = latitudeController.text;

      /*final workingHours = startTimes.keys.map((day) {
        final start = startTimes[day];
        final end = endTimes[day];
        return "$day: ${formatTimeManual(start)} - ${formatTimeManual(end)}";
      }).join(" | ");*/

      final List<String> workingHours = startTimes.keys.map((day) {
        final start = startTimes[day];
        final end = endTimes[day];
        return "$day: ${formatTimeManual(start)} - ${formatTimeManual(end)}";
      }).toList();

      print(workingHours);

      final phone= phoneController.text;
      final email= emailController.text;
      final website= websiteController.text;
      final facebook= facebookController.text;
      final instagram= instagramController.text;
      final tiktok= tiktokController.text;

    //final uri = Uri.parse('http://192.168.0.102:8001/api/restaurants');
    //final uri = Uri.parse('http://multibusiness.velluvom.com:8001/api/restaurants');
      final uri = Uri.parse('http://multibusiness.velluvom.com/api/restaurants');

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'category': category,
          'description': description,
          'address': address,
          'city': city,
          'postcode': postcode,
          'latitude': latitude,
          'longitude': longitude,
          //'images': selectedImages.map((img) => img.path).toList(),
          'images': null,
          'working_hours': workingHours,
         'phone' : phone,
         'email' :  email,
         'website': website,
         'facebook': facebook,
         'instagram': instagram,
         'tiktok': tiktok
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');

      //final jsonResponse
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (var file in selectedImagesProfile) {
          File imageFile = File(file.path);


          //var uri = Uri.parse("http://192.168.0.102:8001/api/upload-image");
          var uti=Uri.parse("http://multibusiness.velluvom.com/api/upload-image");

          print('sent for upload and waiting here');

          String ext = extension(file.path).toLowerCase(); // .jpg, .jpeg, .png
          String mimeType;
          if (ext == '.png') {
            mimeType = 'image/png';
          } else {
            mimeType = 'image/jpeg'; // for .jpg and .jpeg
          }

          var mimeParts = mimeType.split('/');

          var request = http.MultipartRequest('POST', uri)
            ..files.add(await http.MultipartFile.fromPath(
              'image',
              file.path,
              contentType: MediaType(mimeParts[0], mimeParts[1]),
            ));


          final restaurantId = jsonResponse['data']['id'];
          request.fields['restaurant_id'] = restaurantId.toString();
          request.fields['imageCount'] = imageCount.toString();


          var response = await request.send();

          if (response.statusCode == 200) {
            final respStr = await response.stream.bytesToString();
            final jsonResp = jsonDecode(respStr);

            if (jsonResp['success'] == true && jsonResp['url'] != null) {
              uploadedImagePaths.add(jsonResp['url']);
            }

            print("Uploaded: ${jsonResp['url']}");
            imageCount++;
          } else {
            print("Failed to upload ${imageFile.path}. Status: ${response
                .statusCode}");
          }


          for (var file in selectedImages) {
            File imageFile = File(file.path);


            //var uri = Uri.parse("http://192.168.0.102:8001/api/upload-image");
            var uri = Uri.parse("http://multibusiness.velluvom.com/api/upload-image");

            print('sent for upload and waiting here');

            String ext = extension(file.path)
                .toLowerCase(); // .jpg, .jpeg, .png
            String mimeType;
            if (ext == '.png') {
              mimeType = 'image/png';
            } else {
              mimeType = 'image/jpeg'; // for .jpg and .jpeg
            }

            var mimeParts = mimeType.split('/');

            var request = http.MultipartRequest('POST', uri)
              ..files.add(await http.MultipartFile.fromPath(
                'image',
                file.path,
                contentType: MediaType(mimeParts[0], mimeParts[1]),
              ));


            final restaurantId = jsonResponse['data']['id'];
            request.fields['restaurant_id'] = restaurantId.toString();
            request.fields['imageCount'] = imageCount.toString();


            var response = await request.send();

            if (response.statusCode == 200) {
              final respStr = await response.stream.bytesToString();
              final jsonResp = jsonDecode(respStr);

              if (jsonResp['success'] == true && jsonResp['url'] != null) {
                uploadedImagePaths.add(jsonResp['url']);
              }

              print("Uploaded: ${jsonResp['url']}");
              imageCount++;
            } else {
              print("Failed to upload ${imageFile.path}. Status: ${response
                  .statusCode}");
            }
          }
        }
      }

      setState(() {
        //isUploading = false;
        //isUploadingProfile = false;

      });

      return response.statusCode == 200;

    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text("Owner View"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
        ),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Logo section with white background
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


        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [

                SizedBox(height: 16),
                Text(
                  "Register your business to join for the advertisement",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                //buildTextField("Business Name", (val) => name = val),

                buildTextField("Business Name", nameController),


                //buildTextField("Category", (val) => category = val),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    value: category.isNotEmpty ? category : null,
                    items: ['Restaurant', 'Saloon', 'Bakery', 'Others'].map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    /*onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },*/

                    onChanged: isSubmitting ? null : (value) {
                      setState(() {
                        category = value!;
                      });
                    },

                    validator: (val) => val == null || val.isEmpty ? 'Select a category' : null,
                  ),
                ),

                buildTextField("Description", descriptionController),
                buildTextField("Address", addressController),
                buildTextField("City", cityController),
                buildTextField("Postcode", postcodeController),
                buildTextField("Latitude", latitudeController, keyboardType: TextInputType.number),
                buildTextField("Longitude", longitudeController, keyboardType: TextInputType.number),

                ElevatedButton(

                  onPressed: isSubmitting ? null : () => pickTime(context, 'Monday', true),
                  child: Text('Monday - Open'),

                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Monday', false),
                  child: Text('Monday - Close'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Tuesday', true),
                  child: Text('Tuesday - Open'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Tuesday', false),
                  child: Text('Tuesday - Close'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Wednesday', true),
                  child: Text('Wednesday - Open'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Wednesday', false),
                  child: Text('Wednesday - Close'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Thursday', true),
                  child: Text('Thursday - Open'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Thursday', false),
                  child: Text('Thursday - Close'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Friday', true),
                  child: Text('Friday -  Open'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Friday', false),
                  child: Text('Friday - Close'),
                ),

                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Saturday', true),
                  child: Text('Saturday - Open'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Saturday', false),
                  child: Text('Saturday - Close'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Sunday', true),
                  child: Text('Sunday - Open'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : () => pickTime(context, 'Sunday', false),
                  child: Text('Sunday - Close'),
                ),

                buildTextField("Phone", phoneController),
                buildTextField("Email", emailController),
                buildTextField("Website", websiteController),
                buildTextField("Facebook", facebookController),
                buildTextField("Instagram", instagramController),
                buildTextField("Tiktok", tiktokController),

                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: isSubmitting ? null : () => pickAndUploadProfile(context),
                  icon: Icon(Icons.photo_library),
                  label: Text("Select Profile image"),
                ),

                SizedBox(height: 10),
                if (selectedImagesProfile.isNotEmpty)
                  GridView.builder(
                    itemCount: selectedImagesProfile.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(selectedImagesProfile[index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),

                ElevatedButton.icon(
                  onPressed: isSubmitting ? null : () => pickAndUploadImages(context),
                  icon: Icon(Icons.photo_library),
                  label: Text("Add favorite business Images (up to 20)"),
                ),

                SizedBox(height: 10),
                if (selectedImages.isNotEmpty)
                  GridView.builder(
                    itemCount: selectedImages.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return Image.file(
                        File(selectedImages[index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                SizedBox(height: 20),

               /* Stack(
                  children: [
                    GridView.builder(
                      itemCount: selectedImages.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        return Image.file(
                          File(selectedImages[index].path),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    if (isSubmitting)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),*/


                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isSubmitting = true;
                      });

                      bool success = await submitRestaurant();

                      setState(() {
                        isSubmitting = false;
                      });

                      if (success) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('Restaurant Registered Successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                        // Wait a short moment to show the snackbar, then navigate
                        await Future.delayed(Duration(seconds: 2));

                        Navigator.pushReplacement(
                          context,
                          //MaterialPageRoute(builder: (_) => HomePage()), // Or whatever your homepage widget is called
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('Failed to Register Restaurant'),
                              backgroundColor: Colors.red,
                            ),
                          );
                      }



                    }
                  },
                  child: isSubmitting
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text("Submit"),
                ),



              ],
            ),
          ),
        ),
      ),
      ),
      ]
    ));



  }



  Widget buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: !isSubmitting,
        style: TextStyle(color: Colors.black), // 👈 set input text color
        cursorColor: Colors.black,             // 👈 optional: visible cursor
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue), // 👈 label color
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white, // 👈 white background
        ),
        validator: (val) =>
        val == null || val.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

}
