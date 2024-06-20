import 'package:dio/dio.dart';
import 'package:manize/common/http_response_validator.dart';
import 'package:manize/data/evaluationentity.dart';

abstract class IPackageEvaluationDataSource {
  Future<EvaluatinEntity> packageEvaluation(
      String requestId, String score, String note);
  Future<EvaluatinEntity> collectEvaluation(
      String requestId, String score, String note);
}

class PackageEvaluationDataSource
    with HttpResponseValidator
    implements IPackageEvaluationDataSource {
  final Dio httpClient;

  PackageEvaluationDataSource(this.httpClient);
  @override
  Future<EvaluatinEntity> packageEvaluation(
      String requestId, String score, String note) async {
    final response = await httpClient.post('package-request/evaluation',
        data: {'request_id': requestId, 'score': score, 'note': note});
    validateResponse(response);
    return EvaluatinEntity.fromJson(response.data);
  }

  @override
  Future<EvaluatinEntity> collectEvaluation(
      String requestId, String score, String note) async {
    final response = await httpClient.post('collect-request/evaluation',
        data: {'request_id': requestId, 'score': score, 'note': note});
        validateResponse(response);
        return EvaluatinEntity.fromJson(response.data);
  }
}
