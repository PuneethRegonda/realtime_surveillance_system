// import 'package:facemap_app/utils/urls.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';

// class FileUploadWithHttp extends StatefulWidget {
//   @override
//   _FileUploadWithHttpState createState() => _FileUploadWithHttpState();
// }

// class _FileUploadWithHttpState extends State<FileUploadWithHttp> {
//   PlatformFile objFile = null;

//   void chooseFileUsingFilePicker() async {
//     //-----pick file by file picker,
//     var result = await FilePicker.platform.pickFiles(
//       withReadStream:
//           true, // this will return PlatformFile object with read stream
//     );
//     if (result != null) {
//       setState(() {
//         objFile = result.files.single;
//       });
//     }
//   }

//   void uploadSelectedFile() async {
//     //---Create http package multipart request object
//     final request = http.MultipartRequest(
//       "POST",
//       Uri.parse(Urls.uploadPicture),
//     );
//     print(Urls.uploadPicture);

//     //-----add other fields if needed
//     // request.fields["id"] = "abc";
//     //-----add selected file with request
//     request.files.add(new http.MultipartFile(
//         "image", objFile.readStream, objFile.size,
//         filename: objFile.name));
//     //-------Send request
//     var resp = await request.send();
//     //------Read response
//     // String result = await resp.stream.bytesToString();
//     //-------Your response

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: [
//             //------Button to choose file using file picker plugin
//             MaterialButton(
//                 child: Text("Choose File"),
//                 onPressed: () => chooseFileUsingFilePicker()),
//             //------Show file name when file is selected
//             if (objFile != null) Text("File name : ${objFile.name}"),
//             //------Show file size when file is selected
//             if (objFile != null) Text("File size : ${objFile.size} bytes"),
//             //------Show upload button when file is selected
//             MaterialButton(
//                 child: Text("Upload"), onPressed: () => uploadSelectedFile()),
//           ],
//         ),
//       ),
//     );
//   }
// }
