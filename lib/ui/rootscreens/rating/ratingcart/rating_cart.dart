import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:manize/data/repo/package_request_evalution_repo.dart';
import 'package:manize/theme.dart';
import 'package:manize/ui/rootscreens/rating/ratingcart/bloc/rating_cart_item_bloc.dart';
import 'package:shimmer/shimmer.dart';

class RatingCart extends StatefulWidget {
  final String requestId;
  final bool isAPackageRequest;

  const RatingCart({
    super.key,
    required this.theme,
    required this.requestId,
    required this.isAPackageRequest,
  });

  final ThemeData theme;

  @override
  State<RatingCart> createState() => _RatingCartState();
}

class _RatingCartState extends State<RatingCart> {
  final TextEditingController noteController = TextEditingController();
  RatingCartItemBloc? ratingCartItemBloc;
  StreamSubscription<RatingCartItemState>? streamSubscription;

  @override
  void dispose() {
    ratingCartItemBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  String score = "1";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RatingCartItemBloc>(
      create: (context) {
        final bloc = RatingCartItemBloc(packageEvaluationRepository)
          ..add(RatingCartStarted());
        ratingCartItemBloc = bloc;
        streamSubscription = bloc.stream.listen((state) {
          if (state is RatingCartError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        });
        return bloc;
      },
      child: BlocBuilder<RatingCartItemBloc, RatingCartItemState>(
        builder: (context, state) {
          if (state is RatingCartSuccess ||
              state is RatingCartItemInitial ||
              state is RatingCartError) {
            return Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: const Color.fromARGB(255, 138, 179, 44),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        'assets/img/delivery_man.png',
                        width: 78,
                        height: 78,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    " چه میزان ازعملکرد و برخورد پیک",
                    style: widget.theme.textTheme.titleLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "راضی بودین؟",
                    style: widget.theme.textTheme.titleLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    itemSize: 26,
                    minRating: 1,
                    direction: Axis.horizontal,
                    textDirection: TextDirection.ltr,
                    allowHalfRating: false,
                    itemCount: 5,
                    glow: true,
                    glowColor: Colors.white10,
                    unratedColor:
                        LightThemeColors.secondartTextColor.withOpacity(0.3),
                    glowRadius: 1,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.white,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        score = rating.toString();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 42,
                  ),
                  Text(
                    'انتقاد,پیشنهاد/شکایت',
                    style: widget.theme.textTheme.titleLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  state is RatingCartSuccess
                      ? Text(
                          'امتیاز شما با موفقیت ثبت شد',
                          style: widget.theme.textTheme.bodyLarge!.copyWith(
                              color: widget.theme.colorScheme.onPrimary),
                        )
                      : TextField(
                          controller: noteController,
                          maxLines: 2,
                          scrollPadding: const EdgeInsets.only(bottom: 24),
                          decoration: InputDecoration(
                              filled: true,
                              hintText:
                                  'انتقاد پشنهاد و شکایت خود را بنویسید...',
                              hintStyle: widget.theme.textTheme.bodySmall,
                              alignLabelWithHint: true,
                              isCollapsed: false,
                              isDense: false,
                              fillColor: Colors.white),
                        ),
                  const SizedBox(
                    height: 12,
                  ),
                  state is RatingCartSuccess
                      ? SizedBox()
                      : OutlinedButton(
                          onPressed: () {
                            if (state is RatingCartSuccess) {
                              () {};
                            } else {
                              if (noteController.text.isNotEmpty &&
                                  score.isNotEmpty &&
                                  widget.requestId.isNotEmpty) {
                                BlocProvider.of<RatingCartItemBloc>(context)
                                    .add(RatingCartSabtClicked(
                                        score,
                                        widget.requestId,
                                        noteController.text,
                                        context,
                                        widget.isAPackageRequest));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'فیلد توضیحات نمی تواند خالی باشد')));
                              }
                            }
                          },
                          child: Text(
                            state is RatingCartError
                                ? "تلاش مجدد"
                                : "ثبت امتیاز",
                            style: widget.theme.textTheme.bodyMedium,
                          ),
                        ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(
                    thickness: 1,
                    indent: 32,
                    endIndent: 32,
                  ),
                ],
              ),
            );
          } else {
            if (state is RatingCartLoading) {
              return SizedBox(
                height: MediaQuery.of(context).size.width,
                width: 300,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            } else {
              if (state is RatingCartSkltonLoading) {
                return const LoadingSkleton();
              } else {
                throw Exception();
              }
            }
          }
        },
      ),
    );
  }
}

class LoadingSkleton extends StatelessWidget {
  const LoadingSkleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Shimmer.fromColors(
            highlightColor: Colors.grey.shade300,
            baseColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Theme.of(context).dividerColor.withOpacity(0.2)),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 18,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Theme.of(context).dividerColor.withOpacity(0.2)),
                ),
                SizedBox(
                  height: 36,
                ),
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).dividerColor.withOpacity(0.2)),
                ),
              ],
            )),
      ),
    );
  }
}
