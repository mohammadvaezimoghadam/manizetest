import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const colorizeColors = [Colors.white, Colors.white, Colors.white];

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 35,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'مانیزه',
                          textAlign: TextAlign.center,
                          speed: Duration(seconds: 3),
                          colors: colorizeColors,
                          textStyle: TextStyle(
                              fontSize: 80,
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .apply(color: Theme.of(context).colorScheme.onPrimary),
                    child: AnimatedTextKit(
                      pause: Duration(milliseconds: 2000),
                      repeatForever: false,
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                            'سامانه هوشمند جمع آوری پسماند خشک',
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w500,color: Colors.white),
                            textAlign: TextAlign.center,
                            speed: Duration(milliseconds: 100),
                            cursor: ''),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: LoadingAnimationWidget.horizontalRotatingDots(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24)),
              SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
