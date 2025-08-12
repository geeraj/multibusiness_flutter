import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';



void main() {
  runApp(MaterialApp(
    home: UploadImagePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  List<XFile> selectedImages = [];
  List<String> uploadedImagePaths = [];
  bool isUploading = false;

  Future<void> pickAndUploadImages(BuildContext context) async {
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
      isUploading = true;
      uploadedImagePaths.clear();
    });

    for (var file in pickedFiles) {
      File imageFile = File(file.path);

      /*if (!imageFile.path.toLowerCase().endsWith('.png')) {
        print("Skipping non-PNG file: ${imageFile.path}");
        continue;
      }*/

      var uri = Uri.parse("http://192.168.0.102:8001/api/upload-image");
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

      //request.fields['restaurant_id'] = '1';

      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResp = jsonDecode(respStr);

        if (jsonResp['success'] == true && jsonResp['url'] != null) {
          uploadedImagePaths.add(jsonResp['url']);
        }

        print("Uploaded: ${jsonResp['url']}");
      } else {
        print("Failed to upload ${imageFile.path}. Status: ${response.statusCode}");
      }
    }

    setState(() {
      isUploading = false;

    });



    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Upload complete. Uploaded ${uploadedImagePaths.length} images.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload PNG Images"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: isUploading ? null : () => pickAndUploadImages(context),
              icon: Icon(Icons.upload),
              label: Text("Pick & Upload PNG Images (Max 20)"),
            ),
            SizedBox(height: 16),
            if (isUploading) CircularProgressIndicator(),
            if (selectedImages.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  itemCount: selectedImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.file(
                          File(selectedImages[index].path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              color: Colors.black54,
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
