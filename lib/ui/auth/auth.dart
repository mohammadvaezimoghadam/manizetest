import 'package:flutter/material.dart';
import 'package:manize/ui/auth/login/login.dart';
import 'package:manize/ui/auth/singup/singUp.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color textColor = Color(0xffb2d16c);
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: 75, bottom: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مانیزه',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: textColor, fontSize: 34),
                ),
                const SizedBox(
                  height: 30,
                ),
                AspectRatio(
                    aspectRatio: 1.09,
                    child: Image.asset(
                      'assets/img/start_pic.png',
                    )),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'سامانه هوشمند جمع آوری پسماند خشک',
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
                const SizedBox(
                  height: 75,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(37),
                  child: SizedBox(
                    width: 130,
                    height: 38,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  LoginScreen()));
                        },
                        child: Text(
                          'ورود',
                          style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              color: theme.colorScheme.onSecondary),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SingUpScreen()));
                  },
                  child: Text(
                    'ثبت نام',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
