import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  
  Future<String> uploadPhoto(String path) async {
    Uri uri = Uri.parse('http://10.0.2.2:8000/api/photo-upload/');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', path);
    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    print('\n\n');
    print('RESPONSE WITH HTTP');
    print(responseString);
    print('\n\n');
    return responseString;
  }

}