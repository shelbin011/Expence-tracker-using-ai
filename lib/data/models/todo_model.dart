class TodoModel {
  final int? id;
  final String title;
  final bool isCompleted;
  final DateTime date;

  TodoModel({
    this.id,
    required this.title,
    this.isCompleted = false,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
      date: DateTime.parse(map['date']),
    );
  }
}
