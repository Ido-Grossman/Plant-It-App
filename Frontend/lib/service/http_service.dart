import 'dart:async';
import 'dart:convert';

import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;

import '../models/Plant.dart';
import '../models/PlantDetails.dart';

Future<String> uploadPhoto(String path) async {
  Uri uri = Uri.parse('${Consts.getApiLink()}photo-upload/');
  http.MultipartRequest request = http.MultipartRequest('POST', uri);
  http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('file', path);
  request.files.add(multipartFile);

  http.StreamedResponse response = await request.send();
  var responseBytes = await response.stream.toBytes();
  var responseString = utf8.decode(responseBytes);
  print(responseString);
  return responseString;
}

Future<int> signUp(String email, String password) async {
  final url = Uri.parse('${Consts.getApiLink()}accounts/register/');
  try {
    final response = await http.post(url, body: {
      'email': email,
      'password': password
    }).timeout(const Duration(seconds: 10));
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<String?> logIn(String email, String password) async {
  final url = Uri.parse('${Consts.getApiLink()}accounts/login/');
  try {
    final response = await http
        .post(url, body: {'email': email, 'password': password}).timeout(
      const Duration(seconds: 20),
    );
    if (response.statusCode == 404){
      return null;
    }
    var body = jsonDecode(response.body);
    String token = body['token'];
    return token;
  } on TimeoutException {
    return null;
  }
}

Future<int> chooseUsername(String username, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}accounts/set-username/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http
        .post(url, headers: headers, body: {'username': username}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<String?> logInGoogle(String? email, String uid) async {
  final url = Uri.parse('${Consts.getApiLink()}accounts/google-login/');
  try {
    final response =
        await http.post(url, body: {'email': email, 'uid': uid}).timeout(
      const Duration(seconds: 10),
    );
    var body = jsonDecode(response.body);
    String token = body['token'];
    return token;
  } on TimeoutException {
    return null;
  }
}

Future<int> signUpGoogle(String? email, String uid, String password) async {
  final url = Uri.parse('${Consts.getApiLink()}accounts/google-register/');
  try {
    final response = await http.post(url,
        body: {'email': email, 'uid': uid, 'password': password}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<int> forgotPass(String email) async {
  var url = Uri.parse('${Consts.getApiLink()}accounts/forgot-password/');
  try {
    final response = await http.post(url, body: {'email': email}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<int> logOut(String? token) async {
  var url = Uri.parse('${Consts.getApiLink()}accounts/logout/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.post(url, headers: headers).timeout(
          const Duration(seconds: 10),
        );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<Map<String, dynamic>> getUserDetails(String? token, String email) async {
  var url = Uri.parse('${Consts.getApiLink()}users/$email/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers).timeout(
      const Duration(seconds: 10),
    );
    print(response.statusCode);
    return jsonDecode(response.body);
  } on TimeoutException {
    throw TimeoutException;
  }
}

Future<List<Plant>> searchPlants(String query) async {
  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/search/$query/'));

  if (response.statusCode == 200) {
    // Decode the JSON response as a List of dynamic objects
    List<dynamic> jsonResponse = json.decode(response.body);
    // Map the List of dynamic objects to a List of Plant instances
    return jsonResponse.map((plantJson) => Plant.fromJson(plantJson)).toList();
  } else {
    throw Exception('Failed to load plants');
  }
}

Future<PlantDetails> fetchPlantDetails(int plantId) async {
  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/$plantId/'));

  if (response.statusCode == 200) {
    return PlantDetails.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load plant details');
  }
}