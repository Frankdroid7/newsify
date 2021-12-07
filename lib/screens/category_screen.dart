import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:newsify/constants.dart';
import 'package:newsify/models/headline_model.dart';
import 'package:newsify/viewmodels/category_view_model.dart';
import 'package:newsify/widgets/headline_widget.dart';

import '../api_helper.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  static const List<String> categories = [
    'Entertainment',
    'Business',
    'Health',
    'Sport'
  ];

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Newsify'),
          bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: CategoryScreen.categories
                  .map((category) => Tab(
                        child: Text(
                          category,
                          style: TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: CategoryScreen.categories.map((category) {
              return FutureBuilder(
                  future: CategoryScreenViewModel.getNewsByCategory(category),
                  builder: (context, AsyncSnapshot snapShot) {
                    if (snapShot.connectionState == ConnectionState.done) {
                      if (snapShot.hasData && snapShot.data.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: () {
                            setState(() {});
                            return CategoryScreenViewModel.getNewsByCategory(
                                category);
                          },
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapShot.data!.length >= 8
                                  ? 8
                                  : snapShot.data!.length,
                              itemBuilder: (context, index) {
                                HeadlineModel headlineModel =
                                    snapShot.data![index];
                                return HeadlineWidget(
                                  title: headlineModel.title,
                                  imgUrl: headlineModel.imgUrl,
                                  author: headlineModel.author,
                                  newsUrl: headlineModel.newsUrl,
                                );
                              }),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Lottie.asset('assets/lottie/no_data_lottie.json'),
                            const Text(
                              'There is no data at the moment',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: SpinKitFadingFour(
                        color: Colors.teal,
                        size: 50.0,
                      ),
                    );
                  });
            }).toList(),
          ),
        ),
      ),
    );
  }
}
