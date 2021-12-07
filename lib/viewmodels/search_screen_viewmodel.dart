import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:newsify/models/headline_model.dart';

import '../api_helper.dart';

class SearchScreenViewModel {
  static Future searchForNews(String str) async {
    List<HeadlineModel>? headlineModelList = [];
    http.Response response = await ApiHelper.searchNews(str);

    if (response.statusCode == 200) {
      final List responseBody = jsonDecode(response.body)['articles'];

      for (var json in responseBody) {
        headlineModelList.add(HeadlineModel.fromJson(json));
      }
    }
    return headlineModelList;
  }
}
