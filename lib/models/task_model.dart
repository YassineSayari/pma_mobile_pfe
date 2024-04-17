class Task {
  late String id;
  late String title;
  late Map<String,dynamic> project; 
  late String details;
  String status = "Pending";
  late String startDate;
  late String deadLine;
  late List<dynamic> executor;

  late int? progress;
  String priority = "High";

  Task({
    required this.id,
    required this.title,
    required this.project,
    required this.details,
    required this.status,
    required this.startDate,
    required this.deadLine,
    required this.executor,
    this.progress,
    required this.priority,
  });

  Task.fromJson(Map<String, dynamic> json) {
     id = json['_id'];
    title = json['Title'];
    project = json['Project'];
    details = json['Details'] ?? "Waiting for response";
    status = json['Status']??"Pending";
    startDate = json['StartDate'];
    deadLine = json['Deadline'];
    executor = json['Executor'];
    progress = json['progress'] ?? 0;
    priority=json['Priority'] ?? "High";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id']=id;
    data['Title'] = title;
    data['Project'] = project;
    data['Details'] = details;
    data['Status'] = status;
    data['StartDate'] = startDate;
    data['Deadline'] = deadLine;
    data['Executor'] = executor;
    data['progress'] = progress;
    data['Priority']=priority;
    return data;
  }
}
