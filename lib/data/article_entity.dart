class ArticleEntity {
  final String imagUrl;
  final String title;
  final String link;
  final String content;
  final String readTime;
  final String description;

  ArticleEntity.fromJson(Map<String, dynamic> json)
      : imagUrl =json["featured_media"]==0?"": json["yoast_head_json"]["og_image"][0]["url"],
        title = json["title"]["rendered"],
        link = json['link'],
        content = json["content"]["rendered"],
        readTime=json["yoast_head_json"]["twitter_misc"]["زمان تقریبی برای خواندن"]??"0 دقیقه",
        description=json["yoast_head_json"]["og_description"]??"توضیحاتی موجود نیست";
}
