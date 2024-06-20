import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/data/repo/auth_repo.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/auth/code/bloc/code_required_bloc.dart';

class CodeReqoiredScreen extends StatefulWidget {
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? regent;
  final bool isLoginMod;
  const CodeReqoiredScreen({
    super.key,
    required this.phone,
  })  : firstName = null,
        isLoginMod = true,
        regent = null,
        lastName=null;

  const CodeReqoiredScreen.singUp(
      {required this.phone,required this.firstName,required this.regent,required this.lastName})
      : isLoginMod = false;

  @override
  State<CodeReqoiredScreen> createState() => _CodeReqoiredScreenState();
}

class _CodeReqoiredScreenState extends State<CodeReqoiredScreen> {
  CodeRequiredBloc? codeRequiredBloc;
  StreamSubscription<CodeRequiredState>? streamSubscription;
  final TextEditingController codeControler = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription?.cancel();
    codeRequiredBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: BlocProvider<CodeRequiredBloc>(
            create: (context) {
              final bloc = CodeRequiredBloc(authRepository);
              codeRequiredBloc = bloc;
              streamSubscription = bloc.stream.listen((state) {
                if (state is CodeRequiredSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('به مانیزه خوش آمدید')));
                  Navigator.of(context).pop();
                } else if (state is CodeRequiredError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.appException.message)));
                }
              });
              return bloc;
            },
            child: BlocBuilder<CodeRequiredBloc, CodeRequiredState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120,bottom: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/logo.png',
                          width: 90,
                          height: 90,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'کد تایید',
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'ارسال به' +
                                        " " +
                                        "${widget.phone}" +
                                        " " +
                                        "/",
                                    style: theme.textTheme.bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w300),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        codeRequiredBloc!.add(RefreshCodeClicked(widget.phone));
                                      },
                                      child: Text(
                                        'ارسال مجدد',
                                        style: theme.textTheme.bodySmall!.apply(
                                            color: theme.colorScheme.primary),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: codeControler,
                                  cursorHeight: 4,
                                  cursorWidth: 1,
                                  keyboardType: TextInputType.phone,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.8))),
                                      label: Text(
                                        'کد تایید',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: theme.colorScheme.primary
                                                    .withOpacity(0.8)),
                                      ),
                                      hintText: 'کد تایید را وارد کنید',
                                      hintStyle: theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontSize: 14,
                                              color: theme
                                                  .textTheme.bodySmall!.color!
                                                  .withOpacity(0.5))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 120,
                        ),
                        FlotBtn(
                          size: 38,
                          isLoading: state is CodeRequiredLoading,
                          padding: const EdgeInsets.only(right: 58, bottom: 0),
                          nextIconPath: 'assets/icons/add_n.svg',
                          backIconPath: 'assets/icons/back.svg',
                          next: () {
                            if (widget.isLoginMod) {
                              BlocProvider.of<CodeRequiredBloc>(context).add(
                                  CodeBtnClicked(
                                      widget.phone,
                                      codeControler.text,
                                      widget.isLoginMod,
                                      "",
                                      "",
                                      ""));
                            } else {
                              BlocProvider.of<CodeRequiredBloc>(context).add(
                                  CodeBtnClicked(
                                      widget.phone,
                                      codeControler.text,
                                      widget.isLoginMod,
                                      widget.firstName!,
                                      widget.regent!,
                                      widget.lastName!));
                            }
                          },
                          back: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
