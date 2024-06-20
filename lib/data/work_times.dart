class WorkTimesEntity {
  final int id;
  final String startTime;
  final String endTime;

  WorkTimesEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        startTime = json["start_time"],
        endTime = json["end_time"];
}
