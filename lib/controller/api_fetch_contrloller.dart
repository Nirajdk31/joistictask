import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class ApiController extends GetxController{

  Future<List<Map<String, dynamic>>> fetchAlbumData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1/photos'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw showToast('Failed to load album data');
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}

// Future<List<Map<String, dynamic>>> fetchAlbumData() async {
//   final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1/photos'));
//
//   if (response.statusCode == 200) {
//     List<dynamic> data = jsonDecode(response.body);
//     return List<Map<String, dynamic>>.from(data);
//   } else {
//     throw showToast('Failed to load album data');
//   }
// }