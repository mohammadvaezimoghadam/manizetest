
class EvaluatinEntity {
  final bool error;
  final String message;

  EvaluatinEntity.fromJson(Map<String,dynamic> json):
  error=json["error"],
  message=json["message"];
}