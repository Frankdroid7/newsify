import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:newsify/models/headline_model.dart';

import '../api_helper.dart';

class CategoryScreenViewModel {
  static Future getNewsByCategory(String category) async {
    List<HeadlineModel>? headlineModelList = [];
    http.Response response = await ApiHelper.getNewsByCategory(category);

    if (response.statusCode == 200) {
      final List responseBody = jsonDecode(response.body)['articles'];

      for (var json in responseBody) {
        headlineModelList.add(HeadlineModel.fromJson(json));
      }
    }
    return headlineModelList;
  }
}
