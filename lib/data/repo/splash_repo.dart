import 'package:manize/common/http_client.dart';
import 'package:manize/data/splash_data.dart';

import '../source/splash_data_source.dart';

final splashRepository = SplashRepository(SplashDataSource(httpClient));

abstract class ISplashRepository {
  Future<SplashData> getSplashData();
}

class SplashRepository implements ISplashRepository {
  final ISplashDataSource dataSource;

  SplashRepository(this.dataSource);
  @override
  Future<SplashData> getSplashData() {
    return dataSource.getSplashData();
  }
}
