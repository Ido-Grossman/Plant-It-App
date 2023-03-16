import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  
  Future<String> uploadPhoto(String path) async {
    Uri uri = Uri.parse('http://10.0.2.2:8000/api/photo-upload');
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('files', path));

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