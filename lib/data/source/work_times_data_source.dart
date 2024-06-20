import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/work_times.dart';

abstract class IWorkTimesDataSource {
  Future<List<WorkTimesEntity>> getWorkTimes();
}

class WorkTimesDataSource
    with HttpResponseValidator
    implements IWorkTimesDataSource {
  final Dio httpClient;

  WorkTimesDataSource(this.httpClient);
  @override
  Future<List<WorkTimesEntity>> getWorkTimes() async {
    final response = await httpClient.get('work-times');
    validateResponse(response);
    final List<WorkTimesEntity> workTimesList = [];
    (response.data["work_times"] as List).forEach((element) {
      workTimesList.add(WorkTimesEntity.fromJson(element));
    });
    return workTimesList;
  }
}
