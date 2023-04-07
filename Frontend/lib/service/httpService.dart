import 'dart:convert';

import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;

class HttpService {
  
  Future<String> uploadPhoto(String path) async {
    Uri uri = Uri.parse('${Consts.prefixLink}/api/photo-upload/');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', path);
    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    print(responseString);
    return responseString;
  }

}