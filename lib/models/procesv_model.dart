
class Procesv {
  late String id;
  late String title;
  late Map<String,dynamic> project; 
  late String Type_Communication;
  late String date;
  late String description;
  late Map<String, dynamic> sender;
  late List<dynamic> equipe;
  //late String subject;

  Procesv({
    required this.id,
    required this.title,
    required this.description,
    required this.project,
    //required this.subject,
    required this.date,
    required this.sender,
    required this.equipe,
    required this.Type_Communication,
  });

  Procesv.fromJson(Map<String, dynamic> json) {
     id = json['_id'];
    title = json['Titre'];
    project = json['Project'];
    description = json['description'];
    //subject = json['subject'];
    date = json['Date'];
    sender = json['Sender'];
    equipe = json['equipe'];
    Type_Communication=json['Type_Communication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id']=id;
    data['Titre'] = title;
    data['Project'] = project;
    data['description'] = description;
    //data['subject'] = subject;
    data['Date'] = date;
    data['Sender'] = sender;
    data['equipe'] = equipe;
    data['Type_Communication']=Type_Communication;
    return data;
  }
}
