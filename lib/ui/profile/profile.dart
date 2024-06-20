import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/data/repo/auth_repo.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/profile/bloc/profile_bloc.dart';

class ProfieScreen extends StatelessWidget {
  const ProfieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc()..add(ProfileStarted()),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) => state is ProfileSuccess
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(58, 30, 58, 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                            ),
                            Container(
                              width: 134.5,
                              height: 134.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(67.25),
                                  boxShadow: [
                                    BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.1),
                                        blurRadius: 15)
                                  ]),
                              child: SvgPicture.asset(
                                'assets/icons/profile_icon.svg',
                                width: 58,
                              ),
                            ),
                            const SizedBox(
                              height: 48,
                            ),
                            _FildItem(
                              theme: theme,
                              title: 'نام و نام خانوادگی',
                              content: "${state.firstName} ${state.lastName}",
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _FildItem(
                              theme: theme,
                              title: 'شماره تلفن',
                              content: state.phone,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'کد معرفی شما',
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      state.phone,
                                      style: theme.textTheme.bodyMedium!.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 115,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      'معرفی مانیزه',
                                      style: theme.textTheme.titleLarge!.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'با اولین سفارش معرف شما 5 امتیاز دریافت کنید',
                                style: theme.textTheme.bodyMedium!
                                    .apply(color: theme.dividerColor),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(' خروج از حساب کاربری'),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          useRootNavigator: true,
                                          context: context,
                                          builder: (context) {
                                            return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: AlertDialog(
                                                title: const Text('خروج '),
                                                content: Text(
                                                  'آیا میخواهید از حساب خود خارج شوید؟',
                                                  style:
                                                      theme.textTheme.bodyMedium,
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(context);
                                                      },
                                                      child: const Text('خیر')),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await authRepository
                                                            .singOut();
                                                        Navigator.pop(context);
                                                        
                                                      },
                                                      child: const Text('بله')),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    splashRadius: 18,
                                    icon: const Icon(Icons.exit_to_app_outlined))
                              ],
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            FlotBtn(
                                size: 38,
                                nextIconPath: 'assets/icons/close_profile.svg',
                                backIconPath: null,
                                next: () {
                                  Navigator.of(context).pop();
                                },
                                back: () {})
                          ],
                        ),
                      ),
                    )
                  : state is ProfileLLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : state is ProfileEError
                          ? const Center(
                              child: Text('در دریافت اطلاعات خطایی رخ داده است'),
                            )
                          : throw Exception(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FildItem extends StatelessWidget {
  const _FildItem({
    super.key,
    required this.theme,
    required this.title,
    required this.content,
  });

  final ThemeData theme;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            content,
            style: theme.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w300),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
