import 'dart:async';
import 'dart:convert';

import 'package:frontend/constants.dart';
import 'package:http/http.dart' as http;


Future<String> uploadPhoto(String path) async {
  Uri uri = Uri.parse('${Consts.prefixApiLink}/photo-upload/');
  http.MultipartRequest request = http.MultipartRequest('POST', uri);
  http.MultipartFile multipartFile = await http.MultipartFile.fromPath('file', path);
  request.files.add(multipartFile);

  http.StreamedResponse response = await request.send();
  var responseBytes = await response.stream.toBytes();
  var responseString = utf8.decode(responseBytes);
  print(responseString);
  return responseString;
}

Future<int> signUp(String email, String password) async {
  final url = Uri.parse('${Consts.prefixApiLink}accounts/register/');
  try {
    final response = await http
        .post(url, body: {'email': email, 'password': password})
        .timeout(const Duration(seconds: 10));
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<int> logIn(String email, String password) async {
  final url = Uri.parse('${Consts.prefixApiLink}accounts/login/');
  try {
    final response = await http.post(url,
        body: {'email': email, 'password': password}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<int> chooseUsername(String username, String? email) async {
  final url = Uri.parse('${Consts.prefixApiLink}accounts/set-username/');
  try {
    final response = await http.post(url,
        body: {'username': username, 'email': email}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<int> logInGoogle(String? email, String uid) async {
  final url = Uri.parse('${Consts.prefixApiLink}accounts/google-login/');
  try {
    final response = await http.post(url,
        body: {'email': email, 'uid': uid}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}

Future<int> signUpGoogle(String email, String uid, String password) async {
  final url = Uri.parse('${Consts.prefixApiLink}accounts/google-register/');
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
  final url = Uri.parse('${Consts.prefixApiLink}accounts/forgot-password/');
  try {
    final response = await http.post(url,
        body: {'email': email}).timeout(
      const Duration(seconds: 10),
    );
    return response.statusCode;
  } on TimeoutException {
    return -1;
  }
}