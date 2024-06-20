import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manize/carousel/carousel_slider.dart';
import 'package:manize/data/article_entity.dart';
import 'package:manize/res/dimens.dart';
import 'package:manize/ui/article_list/article_list.dart';
import 'package:manize/ui/widgets/slider_item.dart';

class AppSlider extends StatelessWidget {
  AppSlider({
    super.key,
    required this.theme,
    required this.articelList,
    required this.title,
  });

  final ThemeData theme;
  final List<ArticleEntity> articelList;
  final String title;

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  0, AppDimens.small, AppDimens.small, AppDimens.small),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ArticleListScreen()));
                    },
                    child: Row(
                      children: [
                        Text(
                          'مشاهده همه',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        const RotatedBox(
                            quarterTurns: -2,
                            child: Icon(
                              CupertinoIcons.back,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: CarouselSlider.builder(
              carouselController: _controller,
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                viewportFraction: .8,
                // padEnds: false,
                enlargeCenterPage: true,

                aspectRatio: 2.1,
                enlargeStrategy: CenterPageEnlargeStrategy.height,

                autoPlay: true,
                onPageChanged: (index, reason) {},
              ),
              itemCount: articelList.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return SliderItem(
                  imageUrl: articelList[index].imagUrl,
                  title: articelList[index].title,
                  link: articelList[index].link,
                  content: articelList[index].content,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



// final List<String> imagList = [
//   'https://manize.ir/wp-content/uploads/2024/05/سموم-نهان-نقش-پسماندهای-باتری-در-توسعه-بیماری_های-سرطانی.jpg',
//   "https://manize.ir/wp-content/uploads/2022/09/کاهش-تولید-زباله.jpg",
//   "https://manize.ir/wp-content/uploads/2023/03/تغییر-ساعت-تابستانی-1402.jpg",
//   "https://manize.ir/wp-content/uploads/2023/07/ساخت-پول-از-زباله.jpg",
//   "https://manize.ir/wp-content/uploads/2024/01/معرفی-اجزای-باطری.jpg",
//   "https://manize.ir/wp-content/uploads/2024/04/تأثیرات-زیست‌محیطی-باطری‌ها-آلودگی-خاک-و-راه‌های-مقابله.jpg"
// ];




    // final List<Widget> items = imagList.map((e) {
    //   return Padding(
    //     padding: const EdgeInsets.all(AppDimens.medium),
    //     child: Stack(
    //       children: [
    //         Positioned.fill(
    //             top: 100,
    //             right: 65,
    //             left: 65,
    //             bottom: 19,
    //             child: Container(
    //               decoration: BoxDecoration(boxShadow: [
    //                 BoxShadow(blurRadius: 20, color: Color(0xff0d253c))
    //               ]),
    //             )),
    //         Container(
    //           margin: EdgeInsets.only(bottom: 16),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(AppDimens.medium)),
    //           foregroundDecoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(AppDimens.medium),
    //               gradient: LinearGradient(
    //                   begin: Alignment.bottomCenter,
    //                   end: Alignment.center,
    //                   colors: [
    //                     Color(0xff0d253c),
    //                     Colors.transparent,
    //                   ])),
    //           width: double.infinity,
    //           //width:MediaQuery.sizeOf(context).width ,
    //           child: ClipRRect(
    //               borderRadius: BorderRadius.circular(AppDimens.medium),
    //               child: Image.network(
    //                 e,
    //                 fit: BoxFit.cover,
    //               )),
    //         ),
    //         Positioned(
    //           bottom: 30,
    //           right: 20,
    //           left: 12,
    //           child: Text(
    //             'سموم نهان: نقش پسماندهای باتری در توسعه',
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 1,
    //             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                 color: Colors.white,
    //                 fontSize: 17,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }).toList();
