import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newsify/constants.dart';
import 'package:newsify/screens/news_details_page.dart';

class HeadlineWidget extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String author;
  final String newsUrl;

  const HeadlineWidget({
    Key? key,
    required this.title,
    required this.imgUrl,
    required this.author,
    required this.newsUrl,
  }) : super(key: key);

  @override
  Widget build(context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsDetailsPage(
                  newsUrl: newsUrl,
                  title: title,
                )));
      },
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, str) => const SpinKitCircle(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              author,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 200,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
