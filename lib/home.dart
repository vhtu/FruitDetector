import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/label.txt',
    );
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
            colors: [
              Colors.pink[50],
              Colors.pinkAccent,
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "iFruits",
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
              Text(
                "Custom Tensorflow CNN",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(00.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/fruits.png',
                                    ),
                                    SizedBox(height: 40.0),
                                  ],
                                ))
                            : Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 300,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.file(_image),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    _output != null
                                        ? Text(
                                            '${_output[0]['label']}' +
                                                ': ${double.parse((_output[0]['confidence'] * 100).toStringAsFixed(2))}' +
                                                '%',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                            ),
                                          )
                                        : Container(
                                            Text('Tôi khôn biết'),
                                          ),
                                    SizedBox(height: 30.0),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: pickGalleryImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Take a photo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Text(
                                'Camera Roll',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
