class HeadlineModel {
  String title;
  String imgUrl;
  String author;
  String newsUrl;

  HeadlineModel({
    required this.title,
    required this.imgUrl,
    required this.author,
    required this.newsUrl,
  });

  factory HeadlineModel.fromJson(Map<String, dynamic> json) {
    return HeadlineModel(
      title: json['title'],
      newsUrl: json['url'],
      author: json['source']['name'],
      imgUrl: json['urlToImage'] ??
          'https://cdn.pixabay.com/photo/2018/04/16/10/13/newspaper-3324168_960_720.jpg',
    );
  }
}
