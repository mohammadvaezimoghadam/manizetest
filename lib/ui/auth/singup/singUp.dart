import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/data/repo/auth_repo.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/auth/code/coderequiredscreen.dart';
import 'package:manize/ui/auth/singup/bloc/sing_up_bloc.dart';

class SingUpScreen extends StatefulWidget {
  SingUpScreen({super.key});

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController firstNameControler = TextEditingController();
  final TextEditingController lastNameControler = TextEditingController();

  final TextEditingController phoneControler = TextEditingController();

  final TextEditingController regentControler = TextEditingController();

  SingUpBloc? singUpBloc;

  StreamSubscription<SingUpState>? streamSubscription;

  @override
  void dispose() {
    // TODO: implement dispose
    singUpBloc?.close();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocProvider<SingUpBloc>(
            create: (context) {
              final bloc = SingUpBloc(authRepository);
              singUpBloc = bloc;
              streamSubscription = bloc.stream.listen((state) {
                if (state is SingUpError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.appException.message)));
                } else if (state is SingUpSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));

                  Navigator.of(context).pop();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CodeReqoiredScreen.singUp(
                            phone: phoneControler.text,
                            firstName: firstNameControler.text,
                            regent: regentControler.text.isEmpty
                                ? ""
                                : regentControler.text,
                            lastName: lastNameControler.text,
                          )));
                }
              });
              return bloc;
            },
            child: BlocBuilder<SingUpBloc, SingUpState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 85, left: 40, right: 40, bottom: 70),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/logo.png',
                        width: 90,
                        height: 90,
                      ),
                      const SizedBox(
                        height: 42,
                      ),
                      TextField(
                        controller: firstNameControler,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.8))),
                            label: Text(
                              'نام',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.8)),
                            ),
                            hintText: " " + "نام",
                            hintStyle: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                color: theme.textTheme.bodySmall!.color!
                                    .withOpacity(0.5))),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: lastNameControler,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.8))),
                            label: Text(
                              'نام خانوادگی',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.8)),
                            ),
                            hintText: ' ' + "نام خانوادگی",
                            hintStyle: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                color: theme.textTheme.bodySmall!.color!
                                    .withOpacity(0.5))),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: phoneControler,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.8))),
                            label: Text(
                              'شماره تلفن',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.8)),
                            ),
                            hintText: '  ' + '0901*******',
                            hintStyle: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                color: theme.textTheme.bodySmall!.color!
                                    .withOpacity(0.5))),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: regentControler,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.8))),
                            label: Text(
                              'کد معرف' + '(اختیاری)',
                              style: theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.8)),
                            ),
                            hintText: '  ' + 'M45689',
                            hintStyle: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 14,
                                color: theme.textTheme.bodySmall!.color!
                                    .withOpacity(0.5))),
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      FlotBtn(
                        isLoading: state is SingUpLoading,
                        padding: const EdgeInsets.only(right: 58, bottom: 0),
                        nextIconPath: 'assets/icons/next.svg',
                        backIconPath: 'assets/icons/back.svg',
                        next: () {
                          if (firstNameControler.text.isNotEmpty &&
                              phoneControler.text.isNotEmpty) {
                            BlocProvider.of<SingUpBloc>(context)
                                .add(SingUpBtnClicked(phoneControler.text));
                          }
                        },
                        back: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
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
