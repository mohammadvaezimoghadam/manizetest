import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:dio/io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manize/common/http_client.dart';
import 'package:manize/data/repo/auth_repo.dart';
import 'package:manize/data/repo/home_repo.dart';
import 'package:manize/data/repo/splash_repo.dart';
import 'package:manize/data/splash_data.dart';
import 'package:manize/theme.dart';
import 'package:manize/ui/auth/auth.dart';
import 'package:manize/ui/home/bloc/home_bloc.dart';
import 'package:manize/ui/home/home.dart';
import 'package:manize/ui/rootscreens/rating/bloc/rating_screen_bloc.dart';
import 'package:manize/ui/rootscreens/root_screen.dart';
import 'package:manize/ui/splash/splash.dart';
//import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  (httpClient.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
      HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
  (httpClientProduct.httpClientAdapter as IOHttpClientAdapter)
      .createHttpClient = () => HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  WidgetsFlutterBinding.ensureInitialized();
  (httpClientArtiles.httpClientAdapter as IOHttpClientAdapter)
      .createHttpClient = () => HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  WidgetsFlutterBinding.ensureInitialized();

//  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //String version = packageInfo.version;
  // String buildNumber = packageInfo.buildNumber;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin.initialize(InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher_foreground')));
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  } else if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await authRepository.loadAuthInfo();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));

  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (BuildContext context) {
      return const MyApp();
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        fontFamily: 'Vazir', color: LightThemeColors.primaryTextColor);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(homerepository),
        ),
        BlocProvider(create: (context) => RatingScreenBloc()),
      ],
      child: MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          title: 'manize',
          theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              textSelectionTheme: const TextSelectionThemeData(
                selectionHandleColor: LightThemeColors.secondartTextColor,
              ),
              snackBarTheme: SnackBarThemeData(
                  behavior: SnackBarBehavior.floating,
                  closeIconColor: Colors.white,
                  contentTextStyle: const TextStyle(fontFamily: 'Vazir')
                      .copyWith(fontSize: 12, color: Colors.white)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                textStyle: MaterialStateProperty.all(Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w500)),
              )),
              inputDecorationTheme: InputDecorationTheme(
                  labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color:
                              LightThemeColors.primaryColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color:
                              LightThemeColors.primaryColor.withOpacity(0.5)))),
              textTheme: TextTheme(
                  labelMedium: defaultTextStyle,
                  headlineSmall: defaultTextStyle,
                  headlineMedium: defaultTextStyle,
                  titleMedium: defaultTextStyle,
                  labelLarge: defaultTextStyle,
                  headlineLarge: defaultTextStyle,
                  bodyMedium: defaultTextStyle,
                  bodySmall: defaultTextStyle.apply(
                      color: LightThemeColors.secondartTextColor),
                  titleLarge: defaultTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              colorScheme: const ColorScheme.light(surface: Color.fromARGB(255, 177, 215, 89), primary: LightThemeColors.primaryColor, background: Colors.white, secondary: LightThemeColors.secondaryColor, onSecondary: Colors.white)),
          home: AnimatedSplashScreen.withScreenFunction(
            animationDuration: const Duration(microseconds: 500),
            pageTransitionType: PageTransitionType.leftToRightWithFade,
            splashIconSize: MediaQuery.of(context).size.height,
            screenFunction: () async {
              try {
                (httpClient.httpClientAdapter as IOHttpClientAdapter)
                    .createHttpClient = () => HttpClient()
                  ..badCertificateCallback =
                      (X509Certificate cert, String host, int port) => true;
                final splashData = await _getSplashData();
                await Future.delayed(const Duration(seconds: 3));
                if (splashData.collectRequests.isEmpty &&
                    splashData.packageRequests.isEmpty) {
                  return const Directionality(
                      textDirection: TextDirection.rtl, child: MainScreen());
                } else {
                  return Directionality(
                      textDirection: TextDirection.rtl,
                      child: RootForAddAndCollect.rating(
                        packageRequests: splashData.packageRequests,
                        collectRequests: splashData.collectRequests,
                      ));
                }
              } catch (e) {
                return const Directionality(
                    textDirection: TextDirection.rtl, child: MainScreen());
              }
              // await Future.delayed(Duration(seconds: 3));
              // if (splashData.collectRequests.isEmpty &&
              //     splashData.packageRequests.isEmpty) {

              // } else {
              //   return Directionality(
              //       textDirection: TextDirection.rtl, child: RatingScreen());
              // }
            },
            splash: const SplashScreen(),
          )),
    );
  }
}

class FlotBtn extends StatelessWidget {
  final String nextIconPath;
  final String? backIconPath;
  final Function() next;
  final Function() back;
  final EdgeInsetsGeometry padding;
  final double hight;
  final bool isLoading;
  final bool inHome;
  final bool inAddAndColectPackage;
  final Color borderColor;
  final double size;

  const FlotBtn({
    super.key,
    required this.nextIconPath,
    required this.backIconPath,
    required this.next,
    required this.back,
    this.padding = EdgeInsets.zero,
    this.hight = 65,
    this.isLoading = false,
    this.inHome = false,
    this.borderColor = Colors.lightGreen,
    this.size = 24,
    this.inAddAndColectPackage = false,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      height: hight,
      child: Center(
          child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? Container(
                    alignment: Alignment.center,
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(29),
                        color: theme.colorScheme.secondary),
                    child: const CupertinoActivityIndicator())
                : InkWell(
                    borderRadius: BorderRadius.circular(29),
                    onTap: next,
                    child: Container(
                      alignment: Alignment.center,
                      width: 58,
                      height: 58,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: inHome == false
                              ? null
                              : Border.all(
                                  width: 2, strokeAlign: 3, color: borderColor),
                          borderRadius: BorderRadius.circular(29),
                          color: inAddAndColectPackage
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.secondary),
                      child: SvgPicture.asset(
                        nextIconPath,
                        color: theme.colorScheme.onPrimary,
                        width: size,
                      ),
                    ),
                  ),
            backIconPath == null
                ? SizedBox()
                : InkWell(
                    borderRadius: BorderRadius.circular(29),
                    onTap: back,
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 60,
                      child: SizedBox(
                        width: 21,
                        height: 14,
                        child: SvgPicture.asset(
                          backIconPath!,
                        ),
                      ),
                    )),
          ],
        ),
      )),
    );
  }
}

const int homeIndex = 0;
const int authindex = 1;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex =
      AuthRepository.authChangeNotifier.value == null ? authindex : homeIndex;

  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _authKey = GlobalKey();
  late final map = {homeIndex: _homeKey, authindex: _authKey};
  Future<bool> _onWillpop() async {
    final NavigatorState navigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (navigatorState.canPop()) {
      navigatorState.pop();
      return false;
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    AuthRepository.authChangeNotifier.addListener(authChengeNotifierListener);
    super.initState();
  }

  void authChengeNotifierListener() {
    setState(() {
      selectedScreenIndex = AuthRepository.authChangeNotifier.value == null
          ? authindex
          : homeIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillpop,
      child: Scaffold(
        body: IndexedStack(
          index: selectedScreenIndex,
          children: [
            _homeKey.currentState == null && selectedScreenIndex != homeIndex
                ? Container()
                : Navigator(
                    key: _homeKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => Offstage(
                            offstage: selectedScreenIndex != homeIndex,
                            child: const HomeScreen())),
                  ),
            _authKey.currentState == null && selectedScreenIndex != authindex
                ? Container()
                : Navigator(
                    key: _authKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => Offstage(
                            offstage: selectedScreenIndex != authindex,
                            child: AuthScreen())),
                  ),
          ],
        ),
      ),
    );
  }
}

Future<SplashData> _getSplashData() async {
  final response = await splashRepository.getSplashData();

  return response;
}

// Future<Directionality> __splashRoot() async {
//   late final SplashData splashData;

//   final splashData = await _getSplashData();

//   e is AppException && e.responseStatusCode == 401
//       ? const Directionality(
//           textDirection: TextDirection.rtl, child: AuthScreen())
//       : const Directionality(
//           textDirection: TextDirection.rtl, child: MainScreen());

//   if (splashData.collectRequests.isEmpty &&
//       splashData.packageRequests.isEmpty) {
//     return const Directionality(
//         textDirection: TextDirection.rtl, child: MainScreen());
//   } else {
//     return Directionality(
//         textDirection: TextDirection.rtl, child: RatingScreen());
//   }
// }
