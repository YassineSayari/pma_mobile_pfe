class Risk {
  late String id;
  late String title;
  late String action;
  String? details;
  late String impact;
  late String date;
  late Map<String,dynamic> project; 
  late Map<String,dynamic> user;

  Risk({
     required this.id,
    required this.title,
    this.details,
    required this.action,
    required this.impact,
    required this.date,
    required this.user,
    required this.project,
  });

  Risk.fromJson(Map<String, dynamic> json) {
     id = json['_id'];
    title = json['title'];
    details = json['details'];
    action = json['action'];
    impact = json['impact'] ;
    date = json['date'];
    user = json['user'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id']=id;
    data['title'] = title;
    data['details'] = details;
    data['action'] = action;
    data['impact'] = impact;
    data['date'] = date;
    data['user'] = user;
    data['project'] = project;
    return data;
  }
}
