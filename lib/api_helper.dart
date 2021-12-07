import 'package:http/http.dart' as http;
import 'package:newsify/constants.dart';

class ApiHelper {
  static Future getHeadlines() async {
    http.Response response = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=ng'),
        headers: {'Authorization': apiKey});

    return response;
  }

  static Future getGeneralNews() async {
    http.Response response = await http.get(
        Uri.parse('$baseUrl/top-headlines?category=general'),
        headers: {'Authorization': apiKey});

    return response;
  }

  static Future searchNews(String str) async {
    http.Response response = await http.get(
        Uri.parse('$baseUrl/everything?qInTitle=$str'),
        headers: {'Authorization': apiKey});

    return response;
  }

  static Future getNewsByCategory(String category) async {
    http.Response response = await http.get(
        Uri.parse('$baseUrl/top-headlines?category=${category.toLowerCase()}'),
        headers: {'Authorization': apiKey});

    return response;
  }
}
