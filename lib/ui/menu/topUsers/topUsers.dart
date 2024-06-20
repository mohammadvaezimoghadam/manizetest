import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manize/data/repo/top_users_repo.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/menu/topUsers/bloc/top_users_bloc.dart';

class TopUsersScreen extends StatelessWidget {
  const TopUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: BlocProvider<TopUsersBloc>(
        create: (context) =>
            TopUsersBloc(topUsersRepository)..add(TopUsersStarted()),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FlotBtn(
              nextIconPath: 'assets/icons/close_profile.svg',
              size: 38,
              backIconPath: null,
              next: () {
                Navigator.pop(context);
              },
              back: () {}),
          backgroundColor: theme.colorScheme.primary,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 36, left: 48, right: 48,bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(38),
                        color: theme.colorScheme.secondary),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Image.asset(
                          'assets/img/top_users.png',
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 12,
                  ),
                  Text(
                    'نفرات برتر',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocBuilder<TopUsersBloc, TopUsersState>(
                    builder: (context, state) {
                      if (state is TopUsersSuccess) {
                        return Column(
                          children: state.itemsList,
                        );
                      } else {
                        if (state is TopUsersLoading) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        } else {
                          if (state is TopUsersError) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          BlocProvider.of<TopUsersBloc>(context)
                                              .add(TopUsersStarted());
                                        },
                                        child: Text(
                                          "تلاش دوباره",
                                          style: theme.textTheme.bodyMedium,
                                        ))
                                  ],
                                ),
                              ),
                            );
                          } else {
                            throw Exception();
                          }
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopUsersItem extends StatelessWidget {
  final String userName;
  final String fullScore;
  const TopUsersItem({
    super.key,
    required this.userName,
    required this.fullScore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userName,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Text(fullScore),
              const SizedBox(
                width: 4,
              ),
              SvgPicture.asset(
                'assets/icons/score_icon.svg',
                width: 14,
                height: 14,
              )
            ],
          ),
        ],
      ),
    );
  }
}
