import 'package:flutter/material.dart';
import 'package:manize/common/utils.dart';
import 'package:manize/res/dimens.dart';
import 'package:manize/ui/article/article.dart';
import 'package:manize/ui/widgets/image.dart';

class SliderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String link;
  final String content;
  const SliderItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.link,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArticleScreen(
                  imageUrl: imageUrl,
                  tile: title,
                  content: content, link: link,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.medium),
        child: Stack(
          children: [
            Positioned.fill(
                top: 100,
                right: 65,
                left: 65,
                bottom: 19,
                child: Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(blurRadius: 20, color: Color(0xff0d253c))
                  ]),
                )),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.medium)),
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.medium),
                  gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Color(0xff0d253c),
                        Colors.transparent,
                      ])),
              width: double.infinity,
              //width:MediaQuery.sizeOf(context).width ,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.medium),
                  child: ImageLoadingService(
                    imageUrl: imageUrl,
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              left: 12,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
