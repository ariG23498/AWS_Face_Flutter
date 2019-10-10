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

class Selfie extends StatefulWidget {
  @override
  _SelfieState createState() => _SelfieState();
}

class _SelfieState extends State<Selfie> {
  File img_to_send;

  // The fuction which will upload the image as a file
  Future<String> upload(File imageFile) async {
    double ratio = 0.01;
    String url =
        "https://aws-rekognition-api.herokuapp.com/rekog/searchFacesByImage/";

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
      body: json.encode({"file": base64Image}),
      encoding: Encoding.getByName('utf-8'),
    )
        .then((onValue) {
      print(onValue.statusCode.toString());
      // img_returned = imageFromBase64String(onValue.body);

      // setState(() {});
      print(onValue.body);
      String matches =
          "\{\"FaceMatches\":${json.encode(json.decode(onValue.body)['search']['FaceMatches'])}\}";
      print(json.encode(matches));

      // Now the get base 64's
      String urlForGet =
          "https://aws-rekognition-api.herokuapp.com/s3/getImageByKey";

      http
          .post(
        urlForGet,
        headers: {
          "Authorization":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZDlmNTE2NDAzZDUxZjAwMTdlNWJmZDUiLCJpYXQiOjE1NzA3MjIxNDh9.HVCQmVCHIL_EzAeskRI_V8v7Z1CJ4t8gPtSY6IWPwxc",
          "Content-Type": "application/json",
        },
        body: json.decode(json.encode(matches)),
        encoding: Encoding.getByName('utf-8'),
      )
          .then((onValue1) {
        print(onValue1.statusCode.toString());

        print(onValue1.body);
        String img = json.decode(onValue1.body)["data"][0]["Body"];
        img_returned = imageFromBase64String(img);

        setState(() {});
      });
    });
    // * Changed
  }

  void lol() async {
    debugPrint("Lol Activated");
    img_to_send = await ImagePicker.pickImage(source: ImageSource.camera);

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
