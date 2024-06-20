import 'package:dio/dio.dart';
import 'package:manize/data/repo/auth_repo.dart';

final httpClient =
    Dio(BaseOptions(baseUrl: 'https://adminapp.manize.ir/api/user-app/v1/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final authInfo = AuthRepository.authChangeNotifier.value;
          if (authInfo != null && authInfo.accessToken.isNotEmpty) {
            options.headers["Authorization"] = 'Bearer ${authInfo.accessToken}';
            options.headers["Accept"] = 'application/json';
          }

          handler.next(options);
        },
      ));

final httpClientProduct =
    Dio(BaseOptions(baseUrl: 'https://kermansell.ir/wp-json/wc/v3/'))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // options.extra["consumer_key"] =
          //     "ck_55ca50ab7822c3e23241c9bc74f0eea8fdf673a7";
          // options.extra["consumer_secret"] =
          //     "cs_2259a8b2d8f2e7630c4918c3896fe665d12830e4";

          handler.next(options);
        },
      ));

      final httpClientArtiles=Dio();
