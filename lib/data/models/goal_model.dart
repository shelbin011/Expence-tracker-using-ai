class GoalModel {
  final int? id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final bool isCompleted;

  GoalModel({
    this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      title: map['title'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'],
      deadline: DateTime.parse(map['deadline']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
