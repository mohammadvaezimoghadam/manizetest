import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/rootscreens/rating/bloc/rating_screen_bloc.dart';
import 'package:manize/ui/rootscreens/rating/ratingcart/rating_cart.dart';

class RatingScreen extends StatefulWidget {
  final List<int> packageRequests;
  final List<int> collectRequests;

  const RatingScreen(
      {super.key,
      required this.packageRequests,
      required this.collectRequests});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  RatingScreenBloc? ratingScreenBloc;
  StreamSubscription<RatingScreenState>? streamSubscription;
  @override
  void dispose() {
    ratingScreenBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<RatingScreenBloc>(
        create: (context) {
          final bloc = context.read<RatingScreenBloc>()
            ..add(RatingScreenStarted(
                widget.packageRequests, theme, widget.collectRequests));
          ratingScreenBloc = bloc;
          streamSubscription = bloc.stream.listen((state) {
            if (state is RatingIsFineshed) {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Directionality(textDirection: TextDirection.rtl,
                  child: MainScreen())));
            }
          });
          return bloc;
        },
        child: BlocBuilder<RatingScreenBloc, RatingScreenState>(
          builder: (context, state) {
            if (state is RatingScreenSuccessForOne) {
              return Column(
                children: [
                  Text(
                    state.evalutionForPackage
                        ? 'ارزشیابی پیک پکیج'
                        : 'ارزشیابی ماشین جمع آوری',
                    style: theme.textTheme.titleLarge,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Column(
                        children: state.children,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              if (state is RatingScreenSuccessForTow) {
                return Column(
                  children: [
                    EvalutionScreen(
                        theme: theme,
                        title: 'ارزیابی پیک پکیج',
                        children: state.packageChildren),
                    EvalutionScreen(
                        theme: theme,
                        title: "ارزیابی ماشین جمع آوری",
                        children: state.collectChilderen)
                  ],
                );
              } else {
                if (state is RatingScreenLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  if (state is RatingIsFineshed) {
                    return LoadingSkleton();
                  } else {
                    throw Exception();
                  }
                }
              }
            }
          },
        ),
      ),
    );
  }
}

class EvalutionScreen extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final List<Widget> children;

  const EvalutionScreen(
      {super.key,
      required this.theme,
      required this.title,
      required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
