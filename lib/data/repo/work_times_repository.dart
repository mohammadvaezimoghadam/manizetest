import 'package:manize/common/http_client.dart';
import 'package:manize/data/source/work_times_data_source.dart';
import 'package:manize/data/work_times.dart';

final workTimesRepository =
    WorkTimesRepository(WorkTimesDataSource(httpClient));

abstract class IWorkTimesRepository {
  Future<List<WorkTimesEntity>> getWorkTimes();
}

class WorkTimesRepository implements IWorkTimesRepository {
  final IWorkTimesDataSource workTimesDataSource;

  WorkTimesRepository(this.workTimesDataSource);
  @override
  Future<List<WorkTimesEntity>> getWorkTimes() async {
    return await workTimesDataSource.getWorkTimes();
  }
}
