import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:newsify/models/headline_model.dart';
import 'package:newsify/widgets/headline_widget.dart';
import '../api_helper.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'news_details_page.dart';

// ignore_for_file: prefer_const_constructors
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String todays_Date = DateFormat.yMMMMEEEEd().format(DateTime.now());

  late Future<List<HeadlineModel>> topHeadlinesFuture;
  late Future<List<HeadlineModel>> generalNewsFuture;

  Future<List<HeadlineModel>> getTopHeadlines() async {
    List<HeadlineModel>? headlineModelList = [];
    http.Response response = await ApiHelper.getHeadlines();

    if (response.statusCode == 200) {
      final List responseBody = jsonDecode(response.body)['articles'];

      for (var json in responseBody) {
        headlineModelList.add(HeadlineModel.fromJson(json));
      }
    }
    return headlineModelList;
  }

  Future<List<HeadlineModel>> getGeneralNews() async {
    List<HeadlineModel>? headlineModelList = [];
    http.Response response = await ApiHelper.getGeneralNews();

    if (response.statusCode == 200) {
      final List responseBody = jsonDecode(response.body)['articles'];

      for (var json in responseBody) {
        headlineModelList.add(HeadlineModel.fromJson(json));
      }
    }
    return headlineModelList;
  }

  @override
  void initState() {
    super.initState();
    generalNewsFuture = getGeneralNews();
    topHeadlinesFuture = getTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              todays_Date,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Top News',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<HeadlineModel>?>(
                future: topHeadlinesFuture,
                builder:
                    (context, AsyncSnapshot<List<HeadlineModel>?> snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    if (snapShot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapShot.data!.length >= 8
                              ? 8
                              : snapShot.data!.length,
                          itemBuilder: (context, index) {
                            HeadlineModel headlineModel = snapShot.data![index];
                            return HeadlineWidget(
                              title: headlineModel.title,
                              imgUrl: headlineModel.imgUrl,
                              author: headlineModel.author,
                              newsUrl: headlineModel.newsUrl,
                            );
                          });
                    }

                    return Column(
                      children: [
                        SizedBox(height: 30),
                        Lottie.asset('assets/lottie/no_data_lottie.json'),
                        Text(
                          'There is no data at the moment',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SpinKitFadingFour(
                      color: Colors.teal,
                      size: 50.0,
                    ),
                  );
                },
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(
                'Recent News',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<HeadlineModel>?>(
                future: generalNewsFuture,
                builder:
                    (context, AsyncSnapshot<List<HeadlineModel>?> snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    if (snapShot.hasData) {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 20,
                        childAspectRatio: (1 / 1.04),
                        children: snapShot.data!
                            .sublist(
                                0,
                                snapShot.data!.length >= 4
                                    ? 4
                                    : snapShot.data!.length)
                            .map((headlineModel) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewsDetailsPage(
                                        newsUrl: headlineModel.newsUrl,
                                        title: headlineModel.title,
                                      )));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: headlineModel.imgUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, str) =>
                                              SpinKitCircle(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    headlineModel.author,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Expanded(
                                    child: SizedBox(
                                      width: 100,
                                      child: Text(
                                        headlineModel.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Column(
                      children: [
                        SizedBox(height: 30),
                        Lottie.asset('assets/lottie/no_data_lottie.json'),
                        Text(
                          'There is no data at the moment',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SpinKitFadingFour(
                      color: Colors.teal,
                      size: 50.0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
