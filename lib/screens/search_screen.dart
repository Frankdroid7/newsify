import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:newsify/constants.dart';
import 'package:newsify/models/headline_model.dart';
import 'package:newsify/viewmodels/search_screen_viewmodel.dart';
import 'package:newsify/widgets/headline_widget.dart';

import '../api_helper.dart';

// ignore_for_file: prefer_const_constructors
class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String queryStr = '';

  bool searchNews = false;

  Future? searchNewsFuture;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        autofocus: true,
                        validator: (value) =>
                            value!.isNotEmpty ? null : 'Enter a search',
                        onChanged: (value) => queryStr = value,
                        decoration: InputDecoration(
                          hintText: 'Search News',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateColor.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.white;
                          }
                          return Colors.teal;
                        }),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            searchNews = true;
                            searchNewsFuture =
                                SearchScreenViewModel.searchForNews(queryStr);
                          });
                        }
                      },
                      child: Text('Search'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              searchNews
                  ? Expanded(
                      child: FutureBuilder(
                          future: searchNewsFuture,
                          builder: (context, AsyncSnapshot snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.done) {
                              if (snapShot.hasData &&
                                  snapShot.data.isNotEmpty) {
                                return ListView.builder(
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
                                    });
                              }
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Lottie.asset(
                                        'assets/lottie/no_data_lottie.json'),
                                    Text(
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
                          }),
                    )
                  : Text(
                      'Search for a news',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
