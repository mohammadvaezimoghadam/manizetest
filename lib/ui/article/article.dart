import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:manize/common/utils.dart';
import 'package:manize/ui/home/home.dart';
import 'package:manize/ui/widgets/image.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class ArticleScreen extends StatefulWidget {
  ArticleScreen(
      {super.key,
      required this.imageUrl,
      required this.tile,
      required this.content,
      required this.link});
  final String imageUrl;
  final String tile;
  final String content;
  final String link;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ScrollController scrollController = ScrollController();
  bool isend = false;
  // void _scrollListener() {
  //   setState(() {
  //     var position = scrollController.position.pixels;
  //     if (position >= scrollController.position.maxScrollExtent - 10) {
  //       if (!isend) {
  //         isend = false;
  //         isend = true;
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    // scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // dom.Document document = htmlparser.parse(content);
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            LaunchInBrowser.launchInBrowser(Uri.parse(widget.link));
          },
          child: Container(
            width: 111,
            height: 48,
            decoration: BoxDecoration(
                color: themeData.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      color: themeData.colorScheme.primary.withOpacity(0.5))
                ]),
            child: Center(
                child: Text(
              'مشاهده بیشتر',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: themeData.colorScheme.onPrimary),
            )),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: AppBarItems(theme: themeData),
                  ),
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: ImageLoadingService(
                      imageUrl: widget.imageUrl,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    child: Text(
                      widget.tile,
                      style: themeData.textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
                    child: Html(
                      data: widget.content,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 116,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
