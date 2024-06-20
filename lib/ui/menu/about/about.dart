import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/common/http_client.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/menu/about/bloc/about_screen_bloc.dart';
import 'package:manize/ui/menu/menuScreen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<AboutScreenBloc>(
      create: (context) =>
          AboutScreenBloc(httpClient)..add(AboutScreenStarted()),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FlotBtn(
            nextIconPath: 'assets/icons/close_profile.svg',
            size: 38,
            backIconPath: null,
            next: () {
              Navigator.pop(context);
            },
            back: () {}),
        body: Padding(
          padding: const EdgeInsets.only(top: 34, left: 24, right: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            MenuScreenAppBar(theme: theme),
            BlocBuilder<AboutScreenBloc, AboutScreenState>(
              builder: (context, state) {
                if (state is AboutScreenSuccess) {
                  return Text(
                    state.aboutText,
                    style: theme.textTheme.titleMedium,
                  );
                } else {
                  if (state is AboutScreenError) {
                    return Row(
                      children: [
                        const Text(('تلاش دوباره')),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.refresh,
                              size: 14,
                            ))
                      ],
                    );
                  } else {
                    if (state is AboutScreenLoading ||
                        state is AboutScreenInitial) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    } else {
                      throw Exception();
                    }
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
