class Reclamation {
  late String title;
  String? codeRec;
  late String comment;
  String reponse = "Waiting for response";
  late String typeReclamation;
  late String addedDate;
  late String client;
  late String project; 
  String status = "Pending";

  Reclamation({
    required this.title,
    this.codeRec,
    required this.comment,
    required this.typeReclamation,
    required this.addedDate,
    required this.client,
    required this.project,
  });

  Reclamation.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    codeRec = json['CodeRec'];
    comment = json['Comment'];
    reponse = json['reponse'] ?? "Waiting for response";
    typeReclamation = json['Type_Reclamation'];
    addedDate = json['Addeddate'];
    client = json['client'];
    project = json['project'];
    status = json['status'] ?? "Pending";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Title'] = title;
    data['CodeRec'] = codeRec;
    data['Comment'] = comment;
    data['reponse'] = reponse;
    data['Type_Reclamation'] = typeReclamation;
    data['Addeddate'] = addedDate;
    data['client'] = client;
    data['project'] = project;
    data['status'] = status;
    return data;
  }
}
