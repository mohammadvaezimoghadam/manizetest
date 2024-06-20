import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/data/article_entity.dart';
import 'package:manize/data/source/article_data_source.dart';
import 'package:manize/res/dimens.dart';
import 'package:manize/theme.dart';
import 'package:manize/ui/article/article.dart';
import 'package:manize/ui/article_list/bloc/artcle_list_bloc.dart';
import 'package:manize/ui/home/home.dart';
import 'package:manize/ui/widgets/image.dart';

class ArticleListScreen extends StatefulWidget {
  ArticleListScreen({super.key});
  static final Color backgroundColor =
      const Color.fromARGB(110, 213, 216, 226).withOpacity(0.3);

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  ScrollController _scrollController = ScrollController();
  ArtcleListBloc? bloc;
  StreamSubscription? streamSubscription;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (isLoading == false) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc!.add(ArticleListLoadArticels());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<ArtcleListBloc>(
        create: (context) {
          bloc = ArtcleListBloc(ArticleDataSource());
          bloc!.add(ArticleListStarted());
          streamSubscription = bloc!.stream.listen((state) {
            if (state is ArtcleListSuccess) {
              if (state.messege.isNotEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.messege)));
              }
            }
          });

          return bloc!;
        },
        child: Scaffold(
          backgroundColor: ArticleListScreen.backgroundColor,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BlocConsumer<ArtcleListBloc, ArtcleListState>(
              builder: (context, state) {
                if (state is ArtcleListSuccess || state is ArticleCheckState) {
                  ArtcleListState realState = state;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          child: AppBarItems(theme: Theme.of(context)),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 32),
                            itemCount: state is ArticleCheckState
                                ? state.articelList.length
                                : state is ArtcleListSuccess
                                    ? state.articelList.length
                                    : 0,
                            itemBuilder: (context, index) {
                              final List<ArticleEntity> articelList =
                                  state is ArticleCheckState
                                      ? state.articelList
                                      : state is ArtcleListSuccess
                                          ? state.articelList
                                          : [];
                              final ThemeData theme = Theme.of(context);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ArticleScreen(
                                          imageUrl: articelList[index].imagUrl,
                                          tile: articelList[index].title,
                                          content: articelList[index].content,
                                          link: articelList[index].link)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.medium)),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ImageLoadingService(
                                              imageUrl:
                                                  articelList[index].imagUrl,
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                articelList[index].title,
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                articelList[index].description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    theme.textTheme.bodySmall,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "زمان خواندن :",
                                                    style: theme
                                                        .textTheme.bodySmall!
                                                        .copyWith(
                                                            color: LightThemeColors
                                                                .primaryTextColor,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                      articelList[index]
                                                          .readTime,
                                                      style: theme
                                                          .textTheme.bodySmall!
                                                          .copyWith(
                                                              color: LightThemeColors
                                                                  .primaryColor,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        state is ArtcleListSuccess && state.isLoding == false
                            ? const SizedBox()
                            : state is ArticleCheckState && isLoading == false
                                ? const SizedBox()
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  )
                      ],
                    ),
                  );
                } else if (state is ArtcleListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ArtcleListError) {
                  return const Center(
                    child: Text("خطا"),
                  );
                } else {
                  throw Exception();
                }
              },
              listener: (BuildContext context, ArtcleListState state) {
                setState(() {
                  isLoading = state.isLoading;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
