import 'package:manize/common/http_client.dart';
import 'package:manize/data/evaluationentity.dart';
import 'package:manize/data/source/package_request_evaluation_data_Source.dart';

final packageEvaluationRepository =
    PackageEvaluationRepository(PackageEvaluationDataSource(httpClient));

abstract class IPackageEvaluationRepository {
  Future<EvaluatinEntity> packageEvaluation(
      String requestId, String score, String note);
  Future<EvaluatinEntity> collectEvaluation(
      String requestId, String score, String note);
}

class PackageEvaluationRepository implements IPackageEvaluationRepository {
  final IPackageEvaluationDataSource packageEvaluationDataSource;

  PackageEvaluationRepository(this.packageEvaluationDataSource);
  @override
  Future<EvaluatinEntity> packageEvaluation(
      String requestId, String score, String note) {
    return packageEvaluationDataSource.packageEvaluation(
        requestId, score, note);
  }

  @override
  Future<EvaluatinEntity> collectEvaluation(
      String requestId, String score, String note) {
    return packageEvaluationDataSource.collectEvaluation(
        requestId, score, note);
  }
}
