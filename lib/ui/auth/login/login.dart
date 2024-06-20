import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manize/data/repo/auth_repo.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/auth/code/coderequiredscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manize/ui/auth/login/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneCOntroler = TextEditingController();
  LoginBloc? loginBloc;
  StreamSubscription<LoginState>? streamSubscription;
  @override
  void dispose() {
    streamSubscription?.cancel();
    loginBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          body: BlocProvider<LoginBloc>(
            create: (context) {
              final bloc = LoginBloc(authRepository);
              loginBloc = bloc;
              streamSubscription = bloc.stream.listen((state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.appException.message)));
                } else if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));

                  Navigator.of(context).pop();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CodeReqoiredScreen(phone: phoneCOntroler.text)));
                }
              });
              return bloc;
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                          padding: const EdgeInsets.only(left: 75, right: 75),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'شماره تلفن خود را وارد کنید',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: TextField(
                                  controller: phoneCOntroler,
                                  keyboardType: TextInputType.phone,
                                  textDirection: TextDirection.ltr,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.8))),
                                      
                                      prefixStyle:
                                          theme.textTheme.bodySmall!.copyWith(
                                        fontSize: 14,
                                      ),
                                      label: Text(
                                        'شماره تلفن',
                                        style: theme.textTheme.bodySmall!
                                            .copyWith(
                                                color: theme.colorScheme.primary
                                                    .withOpacity(0.8)),
                                      ),
                                      hintText: '09134567890',
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
                          isLoading: state is LoginLoading,
                          padding: const EdgeInsets.only(right: 58, bottom: 0),
                          nextIconPath: 'assets/icons/add_n.svg',
                          backIconPath: 'assets/icons/back.svg',
                          next: () {
                            if (phoneCOntroler.text.isNotEmpty) {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(LoginBtnIsClicked(phoneCOntroler.text));
                            } else {
                              //مسنجر
                            }
                          },
                          back: () {
                            Navigator.of(context).pop();
                          },
                        ),
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

// class NavigationButtns extends StatelessWidget {
//   final Function() next;
//   final String iconPath;
//   final BuildContext context1;
//   const NavigationButtns({
//     super.key,
//     required this.theme,
//     required this.next,
//     required this.iconPath, required this.context1,
//   });

//   final ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(29),
//           onTap: next(),
//           child: Container(
//             alignment: Alignment.center,
//             width: 58,
//             height: 58,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(29),
//                 color: theme.colorScheme.primary),
//             child: SvgPicture.asset(
//               iconPath,
//               // color: theme.colorScheme.onPrimary,
//             ),
//           ),
//         ),
//         GestureDetector(
//             onTap: () {
//               Navigator.pop(context1);
//             },
//             child: Container(
//               alignment: Alignment.center,
//               width: 58,
//               height: 70,
//               child: SizedBox(
//                 width: 21,
//                 height: 14,
//                 child: SvgPicture.asset(
//                   'assets/icons/back.svg',
//                 ),
//               ),
//             ))
//       ],
//     );
//   }
// }
