import 'dart:convert';
import 'package:facemap_app/api/upload_pic_api.dart';
import 'package:facemap_app/screens/user_location_timeLine.dart';
import 'package:facemap_app/utils/result.dart';
import 'package:facemap_app/utils/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        home: UploadPicture()),
  );
}

class UploadPicture extends StatefulWidget {
  @override
  _UploadPictureState createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {

  static PlatformFile objFile = null;
  static String _base64ImageString;
  final picker = ImagePicker();
  static bool _isrecognized = false, _isFaceDetectedNotRecognized = false;
  static bool _ispicked = false;
  static PickedFile pickedFile;
  static String recognizeduserName, recognizedStatus, recognizedconfidence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: kIsWeb
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Upload Picture",
                style: kIsWeb
                    ? TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: Styles.txt_h1)
                    : Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.center,
                child: _base64ImageString == null
                    ? buildNoPicture()
                    : getRecognizedImage(),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .65,
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      chooseFileUsingFilePicker();
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      alignment: Alignment.center,
                      child: Text("Choose the Picture"),
                      decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: MediaQuery.of(context).size.height * .07,
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                      onTap: _ispicked ? uploadSelectedFile : null,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        alignment: Alignment.center,
                        child: Text("Upload"),
                        decoration: BoxDecoration(
                            color: _ispicked
                                ? Colors.green[200]
                                : Colors.grey[350],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        height: MediaQuery.of(context).size.height * .07,
                      )),
                ),
                // MaterialButton(
                //   textColor: Colors.black,
                //   color: Colors.blue[300],
                //   // padding: EdgeInsets.all(50),
                //   onPressed: () {
                //     chooseFileUsingFilePicker();
                //   },
                //   child: Text("Choose the Picture"),
                // ),
                // MaterialButton(
                //     textColor: Colors.black,
                //     color: Colors.blue[300],
                //     // padding: EdgeInsets.all(50),
                //     child: Text("Upload"),
                //     onPressed: _ispicked ? uploadSelectedFile : null),
              ],
            ),
            (!_isFaceDetectedNotRecognized && _isrecognized)
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: InkWell(
                        onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserLocationTimeLine(recognizeduserName)));
                          print("checking history");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          alignment: Alignment.center,
                          child: Text(
                            "Check $recognizeduserName location history",
                          ),
                          decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: MediaQuery.of(context).size.height * .07,
                        )),
                  )
                : Container(),
            _isFaceDetectedNotRecognized
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Message: $recognizedStatus",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: MediaQuery.of(context).size.width * .2,
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget buildNoPicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.23,
          height: MediaQuery.of(context).size.width * 0.33,
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    // height: MediaQuery.of(context).size.width * 0.3,
                    child: Image.asset(
                      "assets/sample_picture_unrecognized.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Sample Image",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Image must have only one face of the person you are interested to find. \nAfter the Image is uploaded we recognize the person in the image and provide the location history of the user.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.23,
          height: MediaQuery.of(context).size.width * 0.33,
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    // height: MediaQuery.of(context).size.width * 0.15,
                    child: Image.asset(
                      "assets/sample_picture_recognized.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Recognized Image",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "If the Image uploaded is having only one face of the person, and meet all the image configurations it will be analyzed by our system.\nIf the person detected is recognized will be able to check the Location History of recognized person.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void checkHistory() {
    return null;
  }

  void chooseFileUsingFilePicker() async {
    setState(() {
      _isrecognized = false;
    });
    //-----pick file by file picker,
    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
    );
    if (result != null) {
      setState(() {
        _ispicked = true;
        objFile = result.files.single;
      });
    }
  }

  Widget getRecognizedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
          child: Image.memory(
            base64Decode(_base64ImageString),
            fit: BoxFit.scaleDown,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            // height: MediaQuery.of(context).size.width * 0.1,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Results:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Status : $recognizedStatus",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Person Name: $recognizeduserName",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Confidence: $recognizedconfidence",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  resetUptoPick() {
    setState(() {
      _isrecognized = false;
      _ispicked = false;
      _isFaceDetectedNotRecognized = false;
    });
  }

  uploadSelectedFile() async {
    resetUptoPick();

    Result result = await UploadAPI.uploadSelectedFile(objFile);
    recognizedStatus = result.message;

    if (result.isSuccess) {
      setState(() {
        // {user_id:"name","confidence": "17%","image":"base64ImageStr"}
        print(result.data["user_id"]);
        _base64ImageString = result.data["image"];
        _isrecognized = result.isSuccess;
        recognizeduserName = result.data["user_id"];
        recognizedconfidence = result.data["confidence"];
        _isFaceDetectedNotRecognized = false;
      });
    } else {
      print("Opps!!");
      setState(() {
        // {user_id:"name","confidence": "17%","image":"base64ImageStr"}
        _isrecognized = result.isSuccess;
        _isFaceDetectedNotRecognized = true;
      });
      print(result.toString());
    }
  }

  // void _uploadPicture() {
  //   UploadAPI.uploadToRecognize(_image, _image.path, pickedFile);
  //   return null;
  // }
}