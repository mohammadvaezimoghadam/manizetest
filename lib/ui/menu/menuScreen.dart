import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/main.dart';
import 'package:manize/ui/menu/about/about.dart';
import 'package:manize/ui/menu/topUsers/topUsers.dart';
import 'package:manize/ui/menu/cash/cashScreen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FlotBtn(
            nextIconPath: 'assets/icons/close_profile.svg',
            backIconPath: null,
            size: 36,
            next: () {
              Navigator.pop(context);
            },
            back: () {}),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuScreenAppBar(theme: theme),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 36, right: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _MenuItems(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CashScreen()));
                            },
                            pathIcon: 'change_score.svg',
                            title: 'تبدیل امتیاز',
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          _MenuItems(
                            onTap: () {},
                            pathIcon: 'messege.svg',
                            title: 'پیام ها',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _MenuItems(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const TopUsersScreen()));
                            },
                            pathIcon: 'first_people.svg',
                            title: 'برترین افراد',
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          _MenuItems(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const AboutScreen()));
                            },
                            pathIcon: 'aboute_us.svg',
                            title: 'درباره ما',
                          ),
                          
                        ],
                      ),
                      const SizedBox(height: 4,),
                      
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class MenuScreenAppBar extends StatelessWidget {
  const MenuScreenAppBar({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/logo.png',
            width: 46,
            height: 46,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'مانیزه',
            style: theme.textTheme.headlineMedium!
                .copyWith(fontWeight: FontWeight.w200, fontSize: 28),
          )
        ],
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final String title;
  final String pathIcon;
  final Function() onTap;
  const _MenuItems({
    super.key,
    required this.title,
    required this.pathIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(110, 213, 216, 226).withOpacity(0.3),
            ),
            child: SvgPicture.asset(
              'assets/icons/$pathIcon',
              width: 60,
              height: 60,
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(title)
      ],
    );
  }
}
