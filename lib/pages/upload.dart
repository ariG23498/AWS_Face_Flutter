import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/widgets.dart';

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Image img_returned;

class UploadBuffer extends StatefulWidget {
  @override
  _UploadBufferState createState() => _UploadBufferState();
}

class _UploadBufferState extends State<UploadBuffer> {
  File img_to_send;

  // The fuction which will upload the image as a file
  Future<String> upload(File imageFile) async {
    double ratio = 0.01;
    String url =
        "https://aws-rekognition-api.herokuapp.com/s3/uploadBuffer/";

    // * Changed
    List<int> imageBytes = imageFile.readAsBytesSync();
    // print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    http
        .post(
      url,
      headers: {
        "Authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDlmNTE2NDAzZDUxZjAwMTdlNWJmZDUiLCJpYXQiOjE1NzA3MjIxNDh9.HVCQmVCHIL_EzAeskRI_V8v7Z1CJ4t8gPtSY6IWPwxc",
        "Content-Type": "text/plain",
      },
      body: json.encode({"file":base64Image}),
      encoding: Encoding.getByName('utf-8'),
    )
        .then((onValue) {
      print(onValue.statusCode.toString());
      // img_returned = imageFromBase64String(onValue.body);

      // setState(() {});
      print(onValue.body);
    });
    // * Changed
  }

  void lol() async {
    debugPrint("Lol Activated");
    img_to_send = await ImagePicker.pickImage(source: ImageSource.gallery);

    debugPrint(img_to_send.toString());
    upload(img_to_send);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: img_returned == null
              ? Text("Nothing yet", style: TextStyle(color: Colors.white))
              : img_returned),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          lol();
        },
      ),
    );
  }
}
