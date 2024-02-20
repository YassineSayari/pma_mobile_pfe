class Event {
  final String id;
  final String title;
  final String category;
  final String? details;
  final DateTime startDate;
  final DateTime endDate;
  final String className;
  final String userId;

  Event({
    required this.id,
    required this.title,
    required this.category,
    this.details,
    required this.startDate,
    required this.endDate,
    required this.className,
    required this.userId,
  });

factory Event.fromJson(Map<String, dynamic> json) {
  try {
    print("parsing event json");
    return Event(
      id: json['_id'],
      title: json['title'],
      category: json['category'],
      details: json['details'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      className: json['className'] ?? '', 
      userId: json['user'],  
    );
  } catch (e) {
    print('Error parsing event JSON: $e');
    return Event(
      id: '',
      title: '',
      category: '',
      details: '',
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      className: '',
      userId: '',
    );
  }
}




  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'title': title,
  //     'category': category,
  //     'details': details,
  //     'startDate': startDate.toIso8601String(),
  //     'endDate': endDate.toIso8601String(),
  //     'className': className,
  //     'user':  userId,
  //   };
  // }
}
