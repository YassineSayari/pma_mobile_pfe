class Project {
  String id;
  String projectName;
  String? description;
  String status;
  String teamLeaderId;
  DateTime dateFin;
  String type;
  DateTime dateDebut;
  String file;
  String client;
  List<String> equipe;
  int noteClient;
  String priority;
  int noteAdmin;
  //double price;
  List<int> noteEquipe;
  double progress;
  String kickoff;
  String hldLld;
  String buildBook;
  String accessDocument;
  String other;
  String other1;
  String other2;
  String other3;

  Project({
    required this.id,
    required this.projectName,
    this.description,
    required this.status,
    required this.teamLeaderId,
    required this.dateFin,
    required this.type,
    required this.dateDebut,
    required this.file,
    required this.client,
    required this.equipe,
    required this.noteClient,
    required this.priority,
    required this.noteAdmin,
    required this.noteEquipe,
    required this.progress,
    required this.kickoff,
    required this.hldLld,
    required this.buildBook,
    required this.accessDocument,
    required this.other,
    required this.other1,
    required this.other2,
    required this.other3,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    print("fromjson");
    print("JSON data: $json");
    try {
      return Project(
        id: json['_id'],
        projectName: json['Projectname'],
        description: json['description'],
        status: json['status'],
        teamLeaderId: json['TeamLeader']['_id'],
        dateFin: DateTime.parse(
            json['dateFin'] != null ? json['dateFin']['\$date'] : ''),
        type: json['type'],
        dateDebut: DateTime.parse(
            json['dateDebut'] != null ? json['dateDebut']['\$date'] : ''),
        file: json['file'],
        client: json['client']['_id'],
        equipe: List<String>.from(
            json['equipe'] != null ? json['equipe'].map((x) => x['_id']) : []),
        noteClient: json['noteClient'] != null
            ? int.tryParse(json['noteClient'].toString()) ?? 0
            : 0,
        priority: json['priority'],
        noteAdmin: json['note_Admin'] != null
            ? int.tryParse(json['note_Admin'].toString()) ?? 0
            : 0,
        noteEquipe: (json['note_equipe'] as List).isNotEmpty
            ? List<int>.from(json['note_equipe'])
            : [],
        progress: json['progress'] is double
            ? json['progress']
            : double.tryParse(json['progress'].toString()) ?? 0.0,
        kickoff: json['kickoff'] ?? '',
        hldLld: json['HLD_LLD'] ?? '',
        buildBook: json['build_book'] ?? '',
        accessDocument: json['access_document'] ?? '',
        other: json['other'] ?? '',
        other1: json['other1'] ?? '',
        other2: json['other2'] ?? '',
        other3: json['other3'] ?? '',
      );
    } catch (e, stacktrace) {
      print("Error during fromJson: $e");
      print("Stacktrace: $stacktrace");
      print("Error occurred while parsing JSON data. Check the following fields:");
      print("note_Client: ${json['note_Client']}");
      print("note_Admin: ${json['note_Admin']}");
      print("note_Equipe: ${json['note_Equipe']}");
      print("progress: ${json['progress']}");
      rethrow;
    }
  }




  Map<String, dynamic> toJson() {
    return {
      'Projectname': projectName,
      'description': description??"",
      'status': status,
      'TeamLeader': teamLeaderId,
      'dateFin': dateFin.toIso8601String(),
      'type': type,
      'dateDebut': dateDebut.toIso8601String(),
      'file': file,
      'client': client,
      'equipe': equipe,
      'note_Client': noteClient,
      'priority': priority,
      'note_Admin': noteAdmin,
      //'price': price,
      'note_equipe': noteEquipe,
      'progress': progress,
      'kickoff': kickoff,
      'HLD_LLD': hldLld,
      'build_book': buildBook,
      'access_document': accessDocument,
      'other': other,
      'other1': other1,
      'other2': other2,
      'other3': other3,
    };
  }
}
