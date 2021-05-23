import 'dart:convert';
import 'package:facemap_app/utils/urls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:facemap_app/utils/result.dart';

class UploadAPI {
  static Future<Result> uploadSelectedFile(PlatformFile objFile) async {
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(Urls.uploadPicture),
    );

    //-----add other fields if needed
    // request.fields["id"] = "abc";
    //-----add selected file with request
    Result result = Result();

    try {
      request.files.add(new http.MultipartFile(
          "image", objFile.readStream, objFile.size,
          filename: objFile.name));
      //-------Send request
      var resp = await request.send();
      //------Read response
      String response = await resp.stream.bytesToString();

      if (response != null) {
        final mapData = json.decode(response);
        if (mapData != null) {
          // status = true
          result.isSuccess = mapData["status"];
          if (result.isSuccess) {
            result.data = mapData["data"];
          }
          result.message = mapData["message"];
        }
        print("Message : ${result.message}");
        return result;
      }
    } catch (e) {
      print("error gotcha $e");
    }
    result.message = "Something went wrong !!";
    return result;
    //-------Your response
  }

//   static Future<Result> uploadToRecognize(
//       Io.File image, String blob, PickedFile pickedFile) async {
//     print("___Uploading_____");
//     Result result = Result();

//     var request = http.MultipartRequest('POST', Uri.parse(Urls.uploadPicture));
//     try {
//       // Uint8List image = Base64Codec().decode(blob);

//       print(blob.substring(5));
//       // print(image.writeAsString(contents));
//       // Io.File _file = NetworkToFileImage(url: blob.substring(5)).file;
//       // final Uint8List bytes = await image.readAsBytes();

//       print("Image string ${image.toString()}");

//       // final bytes = await image.readAsString();
//       // print("image string ${bytes.substring(0, 10)}");
//       // String img64 = base64Encode(bytes);
//       // print(img64.substring(0, 100));

//       var request =
//           http.MultipartRequest('POST', Uri.parse(Urls.uploadPicture));
//       request.files.add(await http.MultipartFile.fromPath('image', image.path));
//       var res = await request.send();

//       request.send();
//     } catch (e) {
//       print("gotcha error");

//       print(e);
//     }

//     // var res = await request.send();

//     // FormData body;
//     // final bytes = await image.readAsBytes();
//     // final MultipartFile file =
//     //     MultipartFile.fromBytes(bytes, filename: "picture");
//     // MapEntry<String, MultipartFile> imageEntry = MapEntry("image", file);
//     // body.files.add(imageEntry);

// //     final formData = FormData.fromMap({
// //       "file": await MultipartFile.fromFile(file.path),
// // //      "file": base64Image,
// //     });

// //     Response response = await Dio().post(
// //       Urls.uploadPicture,
// //       data: body,
// // //        data: {"file":base64Image},
// //     );

//     print("___Uploading_____1");

//     // print(json.decode(response.data));
//     // return null;
//   }

}
