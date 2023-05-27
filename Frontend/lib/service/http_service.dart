import 'dart:async';
import 'dart:convert';

import 'package:frontend/constants.dart';
import 'package:frontend/models/plant_info.dart';
import 'package:http/http.dart' as http;

import '../models/comment.dart';
import '../models/plant.dart';
import '../models/plant_details.dart';
import '../models/post.dart';

Future<Map<String, dynamic>> uploadPhoto(String path, String? token) async {
  Uri uri = Uri.parse('${Consts.getApiLink()}diseases/photo-upload/');
  Map<String, String> headers = {"Authorization": "Token $token"};
  http.MultipartRequest request = http.MultipartRequest('POST', uri);
  http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('file', path);
  request.files.add(multipartFile);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  var responseBytes = await response.stream.toBytes();
  var responseString = utf8.decode(responseBytes);
  Map<String, dynamic> parsedJson = jsonDecode(responseString);
  return parsedJson;
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

Future<int> setUsername(String username, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}accounts/set-username/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http
        .put(url, headers: headers, body: {'username': username}).timeout(
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
    return jsonDecode(response.body);
  } on TimeoutException {
    throw TimeoutException;
  }
}

Future<List<Plant>> searchPlants(String query, {int offset = 0, String? climate, String? category, String? use, int? celsiusMin, int? celsiusMax}) async {
  String queryParams = "?offset=$offset";

  if (climate != null) {
    queryParams += "&climate=$climate";
  }

  if (category != null) {
    queryParams += "&category=$category";
  }

  if (use != null) {
    queryParams += "&use=$use";
  }

  if (celsiusMin != null && celsiusMax != null) {
    queryParams += "&celsiusmin=$celsiusMin&celsiusmax=$celsiusMax";
  }

  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/search/$query/$queryParams'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((plantJson) => Plant.fromJson(plantJson)).toList();
  } else {
    throw Exception('Failed to load plants');
  }
}


Future<PlantInfo> fetchPlantInfo(int plantId) async {
  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/$plantId/'));

  if (response.statusCode == 200) {
    return PlantInfo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load plant details');
  }
}

Future<List<String>> fetchClimate() async {
  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/climates/'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((climate) => climate.toString()).toList();
  } else {
    throw Exception('Failed to load climate');
  }
}

Future<List<String>> fetchCategories() async{
  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/categories/'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((category) => category.toString()).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<String>> fetchUses() async {
  final response = await http.get(Uri.parse('${Consts.getApiLink()}plants/uses/'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((use) => use.toString()).toList();
  } else {
    throw Exception('Failed to load uses');
  }
}

Future<List<PlantDetails>> fetchMyPlants(String email, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}users/$email/plants/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers).timeout(
      const Duration(seconds: 10),
    );
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((plantJson) => PlantDetails.fromJson(plantJson)).toList().cast<PlantDetails>();
  } on TimeoutException {
    throw TimeoutException;
  }
}

Future<int> addPlantToList(String email, String token, int plantId, String nickname) async {
  final url = Uri.parse('${Consts.getApiLink()}users/$email/plants/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.post(url, headers: headers,
        body: {'plant_id': plantId.toString(), 'plant_nickname': nickname}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    throw TimeoutException;
  }
}

Future<int> deletePlantFromList(String email, String? token, int plantId) async {
  final url = Uri.parse('${Consts.getApiLink()}users/$email/plants/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.delete(url, headers: headers,
        body: {'user_plant_id': plantId.toString()}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    throw TimeoutException;
  }
}

Future<int> setDisease(String disease, String? token, int plantId) async {
  final url = Uri.parse('${Consts.getApiLink()}diseases/set-disease/$plantId/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.put(url, headers: headers,
        body: {'disease': disease}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    throw TimeoutException;
  }
}

Future<List<Comment>> fetchComments(int postId, int plantId, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}posts/$plantId/$postId/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers);
    List<dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse);
    return jsonResponse.map((comment) => Comment.fromJson(comment)).toList().cast<Comment>();
  }
    on TimeoutException {
      throw TimeoutException;
    }
}

Future<bool> createComment(int postId, String content, int plantId, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}posts/$plantId/$postId/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.post(url, headers: headers, body: {'content': content}).timeout(
      const Duration(seconds: 10),);
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
  on TimeoutException {
    throw TimeoutException;
  }
}

Future<int> createPost(int plantId, String? token, String title, String content) async {
  final url = Uri.parse('${Consts.getApiLink()}posts/$plantId/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.post(url, headers: headers,
        body: {'title': title, 'content': content}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  }
  on TimeoutException {
    throw TimeoutException;
  }
}

Future<List<Post>> getPosts(int plantId, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}posts/$plantId/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers).timeout(
      const Duration(seconds: 10),
    );
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((post) => Post.fromJson(post)).toList().cast<Post>();
  }
  on TimeoutException {
    throw TimeoutException;
  }
}

Future<List<PlantDetails>> fetchRecommendations(String email, String? token) async {
  final url = Uri.parse('${Consts.getApiLink()}users/$email/recommendation/');
  try {
    Map<String, String> headers = {"Authorization": "Token $token"};
    final response = await http.get(url, headers: headers).timeout(
      const Duration(seconds: 10),
    );
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((plantJson) => PlantDetails.fromJson(plantJson)).toList().cast<PlantDetails>();
  } on TimeoutException {
    throw TimeoutException;
  }
}