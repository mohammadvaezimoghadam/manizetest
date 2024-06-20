import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/data/repo/cash_repo.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/menu/cash/bloc/cash_bloc.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  CashBloc? cashBloc;
  StreamSubscription<CashState>? streamSubscription;
  final GlobalKey<ScaffoldMessengerState> scafoldMessenger = GlobalKey();

  @override
  void dispose() {
    cashBloc?.close();
    streamSubscription?.cancel();
    scafoldMessenger.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: BlocProvider<CashBloc>(
        create: (context) {
          final bloc = CashBloc(cashRepository)
            ..add(CashStarted(theme, context));
          cashBloc != bloc;
          streamSubscription !=
              bloc.stream.listen((state) {
                if (state is CashError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.messeg),
                  ));
                } else if (state is CashSuccess) {
                  if (state.messege.isNotEmpty) {
                    // Navigator.of(context, rootNavigator: true).pop();
                    scafoldMessenger.currentState!
                        .showSnackBar(SnackBar(content: Text(state.messege)));
                  }
                }
              });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: scafoldMessenger,
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
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 36, bottom: 90),
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
                        child: SvgPicture.asset(
                          'assets/icons/score_icon_with.svg',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 12,
                    ),
                    BlocBuilder<CashBloc, CashState>(
                      builder: (context, state) {
                        if (state is CashSuccess ||
                            state is CashDialogLoading) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 38, right: 38),
                            child: Column(
                              children: [
                                Text(
                                  state is CashSuccess
                                      ? state.fullScore
                                      : state is CashDialogLoading
                                          ? state.fullScore
                                          : "",
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                // Column(
                                //   children: state.cartchildren,
                                // ),
                                FutureBuilder<List<CartTypesItem>>(
                                  future: getCartItem(
                                      state is CashSuccess
                                          ? state.moneyList
                                          : state is CashDialogLoading
                                              ? state.moneyList
                                              : [],
                                      state is CashSuccess
                                          ? state.typesList
                                          : state is CashDialogLoading
                                              ? state.typesList
                                              : [],
                                      theme,
                                      state is CashDialogLoading
                                          ? state.isLoading
                                          : false,
                                      context),
                                  builder: (context, snapshot) {
                                    List<Widget> children;
                                    if (snapshot.hasData) {
                                      children = snapshot.data!;
                                    } else if (snapshot.hasError) {
                                      children = <Widget>[
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child:
                                              Text('Error: ${snapshot.error}'),
                                        ),
                                      ];
                                    } else {
                                      children = const <Widget>[
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CupertinoActivityIndicator(),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Text('Awaiting result...'),
                                        ),
                                      ];
                                    }
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: children,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/history.svg',
                                          width: 14,
                                          height: 14,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'آخرین تراکنش ها',
                                          style: theme.textTheme.titleMedium,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        children: state is CashSuccess
                                            ? state.lastTransChildren
                                            : state is CashDialogLoading
                                                ? state.lastTransChildren
                                                : [],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          if (state is CashError) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        BlocProvider.of<CashBloc>(context)
                                            .add(CashStarted(theme, context));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "تلاش دوباره",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          const SizedBox(width: 10,),
                                          Icon(
                                            CupertinoIcons.refresh,
                                            color: theme
                                                .textTheme.bodyMedium!.color,
                                                size: 16,
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            );
                          } else {
                            if (state is CashLoading) {
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              throw Exception();
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LastTransItem extends StatelessWidget {
  final String title;
  final String date;
  final String amount;

  const LastTransItem({
    super.key,
    required this.theme,
    required this.title,
    required this.date,
    required this.amount,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(date,
                    style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.textTheme.bodySmall!.color,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Row(
              children: [
                Text(amount,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w300)),
                const SizedBox(
                  width: 4,
                ),
                SvgPicture.asset(
                  'assets/icons/score_icon.svg',
                  width: 10,
                  height: 10,
                )
              ],
            )
          ],
        ),
        Divider(
          color: theme.colorScheme.secondary,
          thickness: 0.8,
        ),
      ],
    );
  }
}

class CartTypesItem extends StatefulWidget {
  final String title;
  final String id;
  final String baseScore;
  final bool dialogIsLoading;
  final String lastTitle;
  final String question;
  final String amount;
  final BuildContext parentContext;

  CartTypesItem({
    super.key,
    required this.theme,
    required this.title,
    required this.baseScore,
    required this.lastTitle,
    required this.amount,
    required this.question,
    required this.id,
    required this.dialogIsLoading,
    required this.parentContext,
  });

  final ThemeData theme;

  @override
  State<CartTypesItem> createState() => _CartTypesItemState();
}

class _CartTypesItemState extends State<CartTypesItem> {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            showDialog(
                useRootNavigator: true,
                context: context,
                builder: (context) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      backgroundColor: widget.theme.dialogBackgroundColor,
                      titleTextStyle: widget.theme.textTheme.titleMedium,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      actionsAlignment: MainAxisAlignment.center,
                      alignment: Alignment.center,
                      title: Text(widget.question),
                      content: TextField(
                        controller: amountController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                    color: widget.theme.colorScheme.primary)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                    color: widget.theme.colorScheme.primary)),
                            //disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
                            labelStyle: widget.theme.textTheme.bodyMedium!
                                .copyWith(
                                    color: widget.theme.colorScheme.primary,
                                    fontWeight: FontWeight.w300),
                            label: Text('تعداد'),
                            contentPadding: EdgeInsets.all(8)),
                      ),
                      actions: [
                        Column(
                          children: [
                            Divider(
                              endIndent: 18,
                              indent: 18,
                              color: widget.theme.colorScheme.secondary,
                            ),
                            TextButton(
                              onPressed: () {
                                BlocProvider.of<CashBloc>(widget.parentContext)
                                    .add(CashConvertScore(
                                        amountController.text, widget.id));
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: widget.dialogIsLoading
                                  ? CupertinoActivityIndicator(
                                      color: widget.theme.colorScheme.primary,
                                    )
                                  : Text("تبدیل امتیاز"),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: widget.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Container(
                alignment: Alignment.center,
                width: 88,
                height: 55,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 20)
                    ],
                    color: widget.theme.textTheme.headlineMedium!.color,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.baseScore,
                      style: widget.theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          color: widget.theme.colorScheme.primary),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Image.asset(
                      'assets/img/score_icon_primary.png',
                      width: 20,
                      height: 20,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.title,
                  style: widget.theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w300, fontSize: 15),
                ),
              )),
            ]),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 23, right: 23, bottom: 8, top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.lastTitle,
                style: widget.theme.textTheme.bodySmall!
                    .copyWith(color: widget.theme.textTheme.bodySmall!.color),
              ),
              Text(
                widget.amount,
                style: widget.theme.textTheme.bodySmall!
                    .copyWith(color: widget.theme.textTheme.bodySmall!.color),
              )
            ],
          ),
        )
      ],
    );
  }
}
