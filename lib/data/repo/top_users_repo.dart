import 'package:manize/common/http_client.dart';
import 'package:manize/data/base_response.dart';

import '../source/top_users_data_Source.dart';

final topUsersRepository = TopUserRepository(TopUserDataSource(httpClient));

abstract class ITopUserRepository {
  Future<BaseResponse> getTopUsers();
}

class TopUserRepository implements ITopUserRepository {
  final ITopUserDataSource topUserDataSource;

  TopUserRepository(this.topUserDataSource);

  @override
  Future<BaseResponse> getTopUsers() {
    return topUserDataSource.getTopUsers();
  }
}
